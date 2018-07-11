
RSpec.describe "Handle of JSON files" do
  context "loads a JSON file" do
    it "writes in json format" do
      output = StringIO.new
      DataPipe.create do
        log_to StringIO.new

        load_from "spec/sample/1.csv", headers: true
        apply_schema({
          "date" => date_field(format: "%Y-%m-%d"),
          "string" => string_field(format: /^[A-Z]/),
          "int" => int_field(min: 1, max: 100),
          "float" => float_field(min: 1, max: 100),
        })
        write_to :json, output
      end.process!

      expect(output.string).to eq <<-FILE
{"date":"2018-12-31","string":"Carlos","int":34,"float":1.85}
      FILE
    end
  end
end

