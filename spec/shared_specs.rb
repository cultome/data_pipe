
RSpec.shared_examples "step protocol" do |step_name|
  it { should respond_to :next }
  it { should respond_to :on_init }
  it { should respond_to :on_close }
  it { should respond_to :step_name }

  it "identifies by name" do
    expect(subject.step_name).to eq step_name
  end
end
