
RSpec.describe "FieldSchema" do
  it "raises  an exception if 'apply' is not implemented" do
    class FieldTest < DataPipe::Step::SchemaHelper::FieldSchema
    end


    expect{ FieldTest.new.prepare.apply(nil, nil, nil) }.to raise_error "must implement it first!"
  end
end
