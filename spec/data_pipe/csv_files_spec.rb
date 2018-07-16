
RSpec.describe "Handle of CSV files" do
  context "loads a CSV file without header" do
    it "ignore headers if not parsed" do
      output = StringIO.new

      DataPipe.create do
        log_to StringIO.new

        load_from_csv stream: "spec/sample/1.csv"
        write_to_csv stream: output, headers: true
      end.process!

      expect(output.string).to eq <<-FILE
date,string,int,float
2018-12-31,Carlos,34,1.85
      FILE
    end

    it "writes it as is" do
      output = StringIO.new

      DataPipe.create do
        log_to StringIO.new

        load_from_csv stream: "spec/sample/1.csv"
        write_to_csv stream: output
      end.process!

      expect(output.string).to eq <<-FILE
date,string,int,float
2018-12-31,Carlos,34,1.85
      FILE
    end
  end

  context "loads a CSV file with header" do
    it "writes only the data" do
      output = StringIO.new

      DataPipe.create do
        log_to StringIO.new

        load_from_csv stream: "spec/sample/1.csv", headers: true
        write_to_csv stream: output
      end.process!

      expect(output.string).to eq <<-FILE
2018-12-31,Carlos,34,1.85
      FILE
    end

    it "writes along the header" do
      output = StringIO.new

      DataPipe.create do
        log_to StringIO.new

        load_from_csv stream: "spec/sample/1.csv", headers: true
        write_to_csv stream: output, headers: true
      end.process!

      expect(output.string).to eq <<-FILE
date,string,int,float
2018-12-31,Carlos,34,1.85
      FILE
    end
  end
end
