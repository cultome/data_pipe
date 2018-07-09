
RSpec.describe DataPipe do
  context "handles error in the pipe" do
    it "caught error during process" do
      output = StringIO.new

      DataPipe.create do
        load_from "spec/sample/3.csv", headers: true
        handle_error do |err, record|
          puts "[*] Error handler for #{err} - #{record}"
        end
        apply_schema({
          "age" => int_field,
        })
        write_to :csv, output
      end.process!

      expect(output.string).to eq <<-FILE
1982-10-02,34,susana@cultome.io
Carlos,34,
Iker,5,55-55-55-55
      FILE
    end
  end
end
