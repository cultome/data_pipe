require "ostruct"
require "data_pipe/iterable"
require "data_pipe/inputable"

module DataPipe
  class Transformation
    include Iterable
    include Inputable

    attr_reader :params
    attr_reader :fnc

    EMPTY_PARAMS = OpenStruct.new({})

    def initialize(params=EMPTY_PARAMS, &blk)
      @params = params
      @fnc = blk
    end

    def iter
      raise "Implement this method!"
    end
  end
end

require "data_pipe/transformation/map"
require "data_pipe/transformation/process"
require "data_pipe/transformation/filter"
