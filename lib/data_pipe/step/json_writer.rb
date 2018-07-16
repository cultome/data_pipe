require "json"
require "data_pipe/steppable"

module DataPipe::Step
  class JsonWriter
    include DataPipe::Steppable

    def step_command
      :write_to_json
    end

    def write_header?
      false
    end

    def process(record)
      params.stream.puts record.data.to_json
      record
    end
  end
end
