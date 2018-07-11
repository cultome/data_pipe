require "ostruct"
require "data_pipe/step"

module DataPipe
  class Writer
    include Step

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
  end
end

require "data_pipe/writer/csv"
require "data_pipe/writer/json"
