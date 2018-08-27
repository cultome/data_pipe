
RSpec.describe "Step to handle pipe errors" do
  context "handles error in the pipe" do
    it "caught error during process" do
      output = StringIO.new
      handler_called = false
      exception = ""

      DataPipe.create do
        log_to StringIO.new

        load_from_csv stream: "spec/sample/3.csv"
        handle_error do |err|
          exception = err.to_s
          handler_called = true
        end
        apply_schema definition: {
          "age" => int_field,
        }
        write_to_csv stream: output, headers: false
      end.process!

      expect(exception).not_to be_empty
      expect(handler_called).to be true
      expect(output.string).to eq <<-FILE
1982-10-02,34,susana@cultome.io
Carlos,34,
Iker,5,55-55-55-55
      FILE
    end
  end
end
