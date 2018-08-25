
RSpec.describe "Stepable" do
  it "raises an exception if 'process' is not implemented" do
    class StepableTest
      include DataPipe::Stepable
    end

    it = StepableTest.new.set_input([1,2,3]).each
    expect{ it.next }.to raise_error "must implement it first!"
  end
end
