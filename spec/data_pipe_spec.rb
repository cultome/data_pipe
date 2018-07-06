RSpec.describe DataPipe do
  it "loads a csv file and writes a csv file" do
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
end
