require "ostruct"
require "data_pipe/iterable"
require "data_pipe/inputable"

module DataPipe
  class Writer
    include Iterable
    include Inputable

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

    def iter
      raise "must implement it first!"
    end
  end
end

require "data_pipe/writer/csv"
require "data_pipe/writer/json"
