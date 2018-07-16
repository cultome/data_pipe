require "ostruct"

module DataPipe::Step::SchemaHelper
  class FieldSchema
    attr_reader :params

    EMPTY_PARAMS = OpenStruct.new({})

    def apply(value)
      raise "must implement it first!"
    end

    def prepare(params=EMPTY_PARAMS, &blk)
      @params = params
      @fnc = blk
      self
    end
  end
end
