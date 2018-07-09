
RSpec.describe DataPipe do
  context "apply transformations" do
    it "filter fields" do
      output = StringIO.new

      DataPipe.create do
        load_from "spec/sample/1.csv", headers: true
        filter_properties "string", "int"
        write_to :csv, output, headers: true
      end.process!

      expect(output.string).to eq <<-FILE
string,int
Carlos,34
      FILE
    end
  end
end
