require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Degraderator do
  before do
    @degrade      = stub("Degrade")
    # it seems that mocha doesn't let you pass a block that gets
    # the arguments passed to it, and has the result returned. erg.
    @degrade.stubs(:perform).yields.returns(:bar)

    @object       = stub("Something", :foo => :bar)
    @degraderator = Degraderator.new(@degrade, @object)
    @result       = @degraderator.foo("boom")
  end

  it "calls perform" do
    @degrade.should have_received(:perform)
  end

  it "uses method_missing to delegate method calls to the object" do
    @object.should have_received(:foo).with("boom")
  end

  it "returns the result from the object" do
    @result.should == :bar
  end
end