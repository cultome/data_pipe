require "json"
require "data_pipe/stepable"

module DataPipe::Step
  class JsonWriter
    include DataPipe::Stepable

    def step_command
      :write_to_json
    end

    def process(record)
      params.stream.puts record.data.to_json
      record
    end
  end
end
