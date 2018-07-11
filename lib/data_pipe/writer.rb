require "ostruct"
require "data_pipe/step"

module DataPipe::Writer
  class Writer
    include DataPipe::Step

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
