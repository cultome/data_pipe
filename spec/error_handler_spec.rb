
RSpec.describe DataPipe do
  context "handles error in the pipe" do
    it "caught error during process" do
      output = StringIO.new
      handler_called = false

      DataPipe.create do
        log_to StringIO.new

        load_from "spec/sample/3.csv", headers: true
        handle_error do |err|
          handler_called = true
        end
        apply_schema({
          "age" => int_field,
        })
        write_to :csv, output
      end.process!

      expect(handler_called).to be true
      expect(output.string).to eq <<-FILE
1982-10-02,34,susana@cultome.io
Carlos,34,
Iker,5,55-55-55-55
      FILE
    end
  end
end
