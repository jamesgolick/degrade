class Degrade

  attr_reader :name
  attr_reader :minimum, :sample, :threshold, :errors, :failure_strategy
  attr_reader :redis

  # Required elements in the options hash:
  #   :name             - feature name to track status of
  #   :failure_strategy - a callable object to be invoked when too many errors
  #                       seen
  def initialize(redis, options)
    @redis            = redis
    @name             = options.fetch(:name)
    @minimum          = options[:minimum] || 100
    @sample           = options[:sample] || 5000
    @threshold        = options[:threshold] || 0.1
    @errors           = options[:errors] || [StandardError]
    @failure_strategy = options.fetch(:failure_strategy)
  end

  def perform
    begin
      mark_request
      yield
    rescue *errors => e
      mark_failure
      raise e
    end
  end

  def requests
    redis.get(requests_key).to_f
  end

  def failures
    redis.get(failures_key).to_f
  end

  private
    def requests_key
      "status:#{name}:requests"
    end

    def failures_key
      "status:#{name}:failures"
    end

    def mark_request
      redis.incr(requests_key)
      reset_sample
    end

    def mark_failure
      redis.incr(failures_key)
      check_threshold
    end

    def check_threshold
      total_requests = requests
      return if total_requests < minimum

      failure_strategy.call if failures / total_requests >= threshold
    end

    def reset_sample
      if requests > sample
        redis.del(requests_key)
        redis.del(failures_key)
      end
    end
end
