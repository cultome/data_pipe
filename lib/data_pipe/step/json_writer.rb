require "json"
require "data_pipe/stepable"

module DataPipe::Step
  class JsonWriter
    include DataPipe::Stepable

    def step_command
      :write_to_json
    end

    def iter
      if params.respond_to? :stream
        output = params.stream
        close_output = false
      else
        output = open(params.file, "w")
        close_output = true
      end

      Enumerator.new do |rsp|
        input.each do |record|
          output.puts record.data.to_json
          rsp << record
        end

        output.close if close_output
      end
    end
  end
end
