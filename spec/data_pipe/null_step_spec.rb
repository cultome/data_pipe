
RSpec.describe "NullStep" do
  it "returns an empty record whn processed" do
    it = NullStep.new.set_input([1,2,3]).each
    expect(it.next.data).to eq({})
  end
end
