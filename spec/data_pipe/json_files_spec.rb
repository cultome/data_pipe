
RSpec.describe "Handle of JSON files" do
  context "loads a JSON file" do
    before :each do
      File.delete("tmp.json") if File.exists?("tmp.json")
    end

    after :each do
      File.delete("tmp.json") if File.exists?("tmp.json")
    end

    it "reads from a file" do
      output = StringIO.new

      DataPipe.create do
        log_to StringIO.new

        load_from_json file: "spec/sample/1.json"
        write_to_json stream: output
      end.process!

      expect(output.string).to eq <<-FILE
{"date":"2018-12-31","string":"Carlos","int":34,"float":1.85}
      FILE
    end

    it "writes to a file" do
      DataPipe.create do
        log_to StringIO.new

        load_from_json file: "spec/sample/1.json"
        write_to_json file: "tmp.json"
      end.process!

      file_content = File.read("tmp.json")
      expect(file_content).to eq <<-FILE
{"date":"2018-12-31","string":"Carlos","int":34,"float":1.85}
      FILE
    end

    it "writes in json format" do
      output = StringIO.new
      json_file = open("spec/sample/1.json")

      DataPipe.create do
        log_to StringIO.new

        load_from_json stream: json_file
        apply_schema definition: {
          "date" => date_field(format: "%Y-%m-%d"),
          "string" => string_field(format: /^[A-Z]/),
          "int" => int_field(min: 1, max: 100),
          "float" => float_field(min: 1, max: 100),
        }
        write_to_json stream: output
      end.process!

      expect(output.string).to eq <<-FILE
{"date":"2018-12-31","string":"Carlos","int":34,"float":1.85}
      FILE
    end
  end
end

