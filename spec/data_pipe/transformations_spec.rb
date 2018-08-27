
RSpec.describe "Transformations" do
  context "apply transformations" do
    it "select fields" do
      output = StringIO.new

      DataPipe.create do
        log_to StringIO.new

        load_from_csv file: "spec/sample/1.csv", headers: true
        filter_properties keys: ["string", "int"]
        write_to_csv stream: output, headers: true
      end.process!

      expect(output.string).to eq <<-FILE
string,int
Carlos,34
      FILE
    end

    it "excludes fields" do
      output = StringIO.new

      DataPipe.create do
        log_to StringIO.new

        load_from_csv file: "spec/sample/1.csv", headers: true
        filter_properties exclude: true, keys: ["string", "int"]
        write_to_csv stream: output, headers: true
      end.process!

      expect(output.string).to eq <<-FILE
date,float
2118-12-31,1.85
      FILE
    end

    it "custom process fields" do
      output = StringIO.new

      DataPipe.create do
        log_to StringIO.new

        load_from_csv file: "spec/sample/2.csv", headers: true
        apply_schema definition: {
          "age" => int_field,
        }
        filter_records do |record|
          record.data["age"] > 18
        end
        write_to_csv stream: output, headers: true
      end.process!

      expect(output.string).to eq <<-FILE
name,age,email
Susana,34,susana@cultome.io
Carlos,34,csoria@cultome.io
      FILE
    end

    it "map records" do
      output = StringIO.new

      DataPipe.create do
        log_to StringIO.new

        load_from_csv file: "spec/sample/1.csv", headers: true
        map do |record|
          record.data.keys.each{|k| record.data[k] = "test" }
          record
        end
        write_to_csv stream: output, headers: true
      end.process!

      expect(output.string).to eq <<-FILE
date,string,int,float
test,test,test,test
      FILE
    end

    it "visit registry" do
      tapped = false

      DataPipe.create do
        log_to StringIO.new

        load_from_csv file: "spec/sample/1.csv", headers: true
        tap do |record|
          tapped = true
        end
      end.process!

      expect(tapped).to be true
    end
  end
end
