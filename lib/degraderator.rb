class Degraderator
  def initialize(degrade, object)
    @degrade = degrade
    @object  = object
  end

  def method_missing(method, *args)
    @degrade.perform { @object.send(method, *args) }
  end
end