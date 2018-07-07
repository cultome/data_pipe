RSpec.describe DataPipe do
  context "loads a CSV file" do
    it "writes it as is" do
      output = StringIO.new

      DataPipe.create do
        load_from "spec/sample/1.csv"
        write_to :csv, output
      end.process!

      expect(output.string).to eq <<-FILE
date,string,int,float
2018-12-31,Carlos,34,1.85
      FILE
    end

    it "writes only the data file" do
      output = StringIO.new

      DataPipe.create do
        load_from "spec/sample/1.csv", headers: true
        write_to :csv, output
      end.process!

      expect(output.string).to eq <<-FILE
2018-12-31,Carlos,34,1.85
      FILE
    end

    it "writes also the header" do
      output = StringIO.new

      DataPipe.create do
        load_from "spec/sample/1.csv", headers: true
        write_to :csv, output, headers: true
      end.process!

      expect(output.string).to eq <<-FILE
date,string,int,float
2018-12-31,Carlos,34,1.85
      FILE
    end

    it "ignore the write of headers if were not parsed" do
      output = StringIO.new

      DataPipe.create do
        load_from "spec/sample/1.csv"
        write_to :csv, output, headers: true
      end.process!

      expect(output.string).to eq <<-FILE
date,string,int,float
2018-12-31,Carlos,34,1.85
      FILE
    end

    it "writes in json format" do
      output = StringIO.new

      DataPipe.create do
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

    context "validates against a schema" do
      it "success #date_field" do
        output = StringIO.new

        DataPipe.create do
          load_from "spec/sample/1.csv", headers: true
          apply_schema({
            "date" => date_field(format: "%Y-%m-%d"),
          })
          write_to :csv, output
        end.process!

        expect(output.string).to eq <<-FILE
2018-12-31,Carlos,34,1.85
        FILE
      end

      it "failed #date_field" do
        pipe = DataPipe.create do
          load_from "spec/sample/1.csv", headers: true
          apply_schema({
            "date" => date_field(format: "%m-%d-%Y"),
          })
        end

        expect{ pipe.process! }.to raise_error "validation error"
      end

      it "success #string_field" do
        output = StringIO.new

        DataPipe.create do
          load_from "spec/sample/1.csv", headers: true
          apply_schema({
            "string" => string_field(format: /^[A-Z]/),
          })
          write_to :csv, output
        end.process!

        expect(output.string).to eq <<-FILE
2018-12-31,Carlos,34,1.85
        FILE
      end

      it "failed #string_field" do
        pipe = DataPipe.create do
          load_from "spec/sample/1.csv", headers: true
          apply_schema({
            "string" => string_field(format: /^[0-9]/),
          })
        end

        expect{ pipe.process! }.to raise_error "validation error"
      end

      it "success #int_field" do
        output = StringIO.new

        DataPipe.create do
          load_from "spec/sample/1.csv", headers: true
          apply_schema({
            "int" => int_field(min: 1, max: 100),
          })
          write_to :json, output
        end.process!

        expect(output.string).to eq <<-FILE
{"date":"2018-12-31","string":"Carlos","int":34,"float":"1.85"}
        FILE
      end

      it "failed #int_field" do
        pipe = DataPipe.create do
          load_from "spec/sample/1.csv", headers: true
          apply_schema({
            "int" => int_field(min: 1, max: 10),
          })
        end

        expect{ pipe.process! }.to raise_error "validation error"
      end

      it "success #float_field" do
        output = StringIO.new

        DataPipe.create do
          load_from "spec/sample/1.csv", headers: true
          apply_schema({
            "float" => float_field(min: 1, max: 100),
          })
          write_to :json, output
        end.process!

        expect(output.string).to eq <<-FILE
{"date":"2018-12-31","string":"Carlos","int":"34","float":1.85}
        FILE
      end

      it "failed #float_field" do
        pipe = DataPipe.create do
          load_from "spec/sample/1.csv", headers: true
          apply_schema({
            "float" => float_field(min: 2, max: 10),
          })
        end

        expect{ pipe.process! }.to raise_error "validation error"
      end
    end
  end
end
