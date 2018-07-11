require "ostruct"
require "data_pipe/step"

module DataPipe
  class Transformation
    include Step

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
