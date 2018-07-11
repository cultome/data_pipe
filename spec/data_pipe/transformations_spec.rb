
RSpec.describe "Transformations" do
  context "apply transformations" do
    it "filter fields" do
      output = StringIO.new

      DataPipe.create do
        log_to StringIO.new

        load_from "spec/sample/1.csv", headers: true
        filter_properties "string", "int"
        write_to :csv, output, headers: true
      end.process!

      expect(output.string).to eq <<-FILE
string,int
Carlos,34
      FILE
    end

    it "custom process fields" do
      output = StringIO.new

      DataPipe.create do
        log_to StringIO.new

        load_from "spec/sample/2.csv", headers: true
        apply_schema({
          "age" => int_field,
        })
        filter_records do |record|
          record["age"] > 18
        end
        write_to :csv, output, headers: true
      end.process!

      expect(output.string).to eq <<-FILE
name,age,email
Susana,34,susana@cultome.io
Carlos,34,csoria@cultome.io
      FILE
    end

    it "custom process fields" do
      output = StringIO.new

      DataPipe.create do
        log_to StringIO.new

        load_from "spec/sample/1.csv", headers: true
        map do |record|
          record.reduce({}){|acc,(k,_)| acc[k] = "test"; acc }
        end
        write_to :csv, output, headers: true
      end.process!

      expect(output.string).to eq <<-FILE
date,string,int,float
test,test,test,test
      FILE
    end
  end
end
