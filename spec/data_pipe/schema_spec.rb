
RSpec.describe "Schema definition and validations" do
  context "validates with schema" do
    it "date_field success" do
      output = StringIO.new

      DataPipe.create do
        log_to StringIO.new

        load_from_csv stream: "spec/sample/1.csv", headers: true
        apply_schema definition: {
          "date" => date_field(format: "%Y-%m-%d"),
        }
        write_to_csv stream: output
      end.process!

      expect(output.string).to eq <<-FILE
2018-12-31,Carlos,34,1.85
      FILE
    end

    it "date_field failed" do
      pipe = DataPipe.create do
        log_to StringIO.new

        load_from_csv stream: "spec/sample/1.csv", headers: true
        apply_schema definition: {
          "date" => date_field(format: "%m-%d-%Y"),
        }
      end

      expect{ pipe.process! }.to raise_error(ValidationError)
    end

    it "string_field success" do
      output = StringIO.new

      DataPipe.create do
        log_to StringIO.new

        load_from_csv stream: "spec/sample/1.csv", headers: true
        apply_schema definition: {
          "string" => string_field(format: /^[A-Z]/),
        }
        write_to_csv stream: output
      end.process!

      expect(output.string).to eq <<-FILE
2018-12-31,Carlos,34,1.85
      FILE
    end

    it "string_field failed" do
      pipe = DataPipe.create do
        log_to StringIO.new

        load_from_csv stream: "spec/sample/1.csv", headers: true
        apply_schema definition: {
          "string" => string_field(format: /^[0-9]/),
        }
      end

      expect{ pipe.process! }.to raise_error(ValidationError)
    end

    it "int_field success" do
      output = StringIO.new

      DataPipe.create do
        log_to StringIO.new

        load_from_csv stream: "spec/sample/1.csv", headers: true
        apply_schema definition: {
          "int" => int_field(min: 1, max: 100),
        }
        write_to_json stream: output
      end.process!

      expect(output.string).to eq <<-FILE
{"date":"2018-12-31","string":"Carlos","int":34,"float":"1.85"}
      FILE
    end

    it "int_field failed" do
      pipe = DataPipe.create do
        log_to StringIO.new

        load_from_csv stream: "spec/sample/1.csv", headers: true
        apply_schema definition: {
          "int" => int_field(min: 1, max: 10),
        }
      end

      expect{ pipe.process! }.to raise_error(ValidationError)
    end

    it "float_field success" do
      output = StringIO.new

      DataPipe.create do
        log_to StringIO.new

        load_from_csv stream: "spec/sample/1.csv", headers: true
        apply_schema definition: {
          "float" => float_field(min: 1, max: 100),
        }
        write_to_json stream: output
      end.process!

      expect(output.string).to eq <<-FILE
{"date":"2018-12-31","string":"Carlos","int":"34","float":1.85}
      FILE
    end

    it "float_field failed" do
      pipe = DataPipe.create do
        log_to StringIO.new

        load_from_csv stream: "spec/sample/1.csv", headers: true
        apply_schema definition: {
          "float" => float_field(min: 2, max: 10),
        }
      end

      expect{ pipe.process! }.to raise_error(ValidationError)
    end
  end
end


