
RSpec.describe "Handle of CSV files" do
  context "loads a CSV file without header" do
    it "ignore headers if not parsed" do
      output = StringIO.new

      DataPipe.create do
        log_to StringIO.new

        load_from_csv file: "spec/sample/1.csv", headers: false
        write_to_csv stream: output
      end.process!

      expect(output.string).to eq <<-FILE
date,string,int,float
2118-12-31,Carlos,34,1.85
      FILE
    end

    it "writes it as is" do
      output = StringIO.new

      DataPipe.create do
        log_to StringIO.new

        load_from_csv file: "spec/sample/1.csv", headers: false
        write_to_csv stream: output, headers: false
      end.process!

      expect(output.string).to eq <<-FILE
date,string,int,float
2118-12-31,Carlos,34,1.85
      FILE
    end
  end

  context "loads a CSV file with header" do
    it "writes only the data" do
      output = StringIO.new

      DataPipe.create do
        log_to StringIO.new

        load_from_csv file: "spec/sample/1.csv"
        write_to_csv stream: output, headers: false
      end.process!

      expect(output.string).to eq <<-FILE
2118-12-31,Carlos,34,1.85
      FILE
    end

    it "writes along the header" do
      output = StringIO.new

      DataPipe.create do
        log_to StringIO.new

        load_from_csv file: "spec/sample/1.csv"
        write_to_csv stream: output
      end.process!

      expect(output.string).to eq <<-FILE
date,string,int,float
2118-12-31,Carlos,34,1.85
      FILE
    end
  end

  context "writes to a file" do
    before :each do
      File.delete("tmp.csv") if File.exists?("tmp.csv")
    end

    after :each do
      File.delete("tmp.csv") if File.exists?("tmp.csv")
    end

    it "writes to a file" do
      DataPipe.create do
        log_to StringIO.new

        load_from_csv file: "spec/sample/1.csv"
        write_to_csv file: "tmp.csv"
      end.process!

      file_content = open("tmp.csv").read
      expect(file_content).to eq <<-FILE
date,string,int,float
2118-12-31,Carlos,34,1.85
      FILE
    end
  end

end
