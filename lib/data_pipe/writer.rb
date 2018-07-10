require "ostruct"
require "data_pipe/iterable"

module DataPipe
  class Writer
    include Iterable

    attr_reader :params
    attr_reader :output
    attr_reader :input

    EMPTY_PARAMS = OpenStruct.new({})

    def initialize(output, params=EMPTY_PARAMS)
      @params = params
      @output = output
    end

    def set_input(step)
      @input = step
      self
    end

    def write_header?
      false
    end

    def iter
      raise "must implement it first!"
    end
  end
end

require "data_pipe/writer/csv"
require "data_pipe/writer/json"
