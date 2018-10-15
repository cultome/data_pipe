
RSpec.shared_examples "step protocol" do
  it { should respond_to :next }

  it "raise exception when no more elements to process" do
    expect{subject.next}.to raise_exception DataPipe::NoMoreElements
  end
end
