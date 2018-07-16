require "json"
require "data_pipe/steppable"

module DataPipe::Step
  class JsonWriter
    include DataPipe::Steppable

    attr_reader :params
    attr_reader :output

    EMPTY_PARAMS = OpenStruct.new({})

    def initialize(output, params=EMPTY_PARAMS)
      @params = params
      @output = output
    end

    def write_header?
      false
    end

    def process(record)
      output.puts record.data.to_json
      record
    end
  end
end
