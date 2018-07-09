require "ostruct"

module DataPipe
  class FieldSchema
    attr_reader :params

    EMPTY_PARAMS = OpenStruct.new({})

    def initialize(params=EMPTY_PARAMS)
      @params = params
    end

    def apply(value)
      raise "must implement it first!"
    end
  end
end
