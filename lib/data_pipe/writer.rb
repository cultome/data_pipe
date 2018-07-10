module DataPipe
  class Writer
    attr_reader :params
    attr_reader :output
    attr_reader :input

    def initialize(output, params)
      @params = params
      @output = output
    end

    def set_input(step)
      @input = step
    end

    def write_header?
      false
    end

    def each
      raise "must implement it first!"
    end
  end
end

require "data_pipe/writer/csv"
require "data_pipe/writer/json"
