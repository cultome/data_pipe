
module DataPipe
  class Transformation
    attr_reader :params
    attr_reader :input

    def initialize(params)
      @params = params
    end

    def set_input(prev_step)
      @input = prev_step
    end

    def each
      raise "Implement this menthod!"
    end
  end
end

require "data_pipe/transformation/map"
require "data_pipe/transformation/process"
require "data_pipe/transformation/filter"
