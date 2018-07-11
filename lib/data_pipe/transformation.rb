require "ostruct"
require "data_pipe/step"

module DataPipe::Transformation
  class Transformation
    include DataPipe::Step

    attr_reader :params
    attr_reader :fnc

    EMPTY_PARAMS = OpenStruct.new({})

    def initialize(params=EMPTY_PARAMS, &blk)
      @params = params
      @fnc = blk
    end
  end
end

require "data_pipe/transformation/map"
require "data_pipe/transformation/process"
require "data_pipe/transformation/filter"
