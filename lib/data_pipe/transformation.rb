require "ostruct"
require "data_pipe/iterable"

module DataPipe
  class Transformation
    include Iterable

    attr_reader :params
    attr_reader :input
    attr_reader :fnc

    EMPTY_PARAMS = OpenStruct.new({})

    def initialize(params=EMPTY_PARAMS, &blk)
      @params = params
      @fnc = blk
    end

    def set_input(prev_step)
      @input = prev_step
      self
    end

    def iter
      raise "Implement this method!"
    end
  end
end

require "data_pipe/transformation/map"
require "data_pipe/transformation/process"
require "data_pipe/transformation/filter"
