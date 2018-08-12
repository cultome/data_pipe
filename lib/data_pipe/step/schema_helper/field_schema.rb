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

      @params.each_pair do |key, val|
        @params.define_singleton_method("#{key}?"){ !val.nil? }
      end

      @params.define_singleton_method(:method_missing) do |mtd, *args, &bk|
        if mtd.to_s.end_with? "?"
          return false
        end

        super(mtd, *args, &bk)
      end

      self
    end
  end
end
