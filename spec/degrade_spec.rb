require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Degrade" do
  before do
    @redis        = Redis.new
    @failure_proc = stub(:call => nil)
    @degrade      = Degrade.new(@redis, :name             => :chat_service, 
                                        :sample           => 100,
                                        :minimum          => 100,
                                        :threshold        => 0.1,
                                        :errors           => [StandardError],
                                        :failure_strategy => @failure_proc)
  end

  describe "when there's an error" do
    it "reraises the error" do
      lambda { @degrade.perform { raise "asdf" } }.should raise_error
    end
  end

  describe "when the threshold is reached before the minimum number of requests" do
    before do
      9.times { @degrade.perform { } }
      @degrade.perform { raise "" } rescue nil
    end

    it "doesn't call the failure strategy" do
      @failure_proc.should_not have_received(:call)
    end
  end

  describe "when the threshold is reached" do
    before do
      90.times { @degrade.perform {} }
      10.times { @degrade.perform { raise "" } rescue nil }
    end

    it "calls the failure strategy" do
      @failure_proc.should have_received(:call)
    end
  end

  describe "when the requests grow above the sample" do
    before do
      @degrade.perform { raise "" } rescue nil
      100.times { @degrade.perform { } }
    end

    it "resets the counter" do
      @degrade.requests.should == 0
    end

    it "resets the requests" do
      @degrade.failures.should == 0
    end
  end
end
