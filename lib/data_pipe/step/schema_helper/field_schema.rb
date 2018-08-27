require "ostruct"

module DataPipe::Step::SchemaHelper
  class FieldSchema
    attr_reader :params

    def apply(value, field, record)
      raise "must implement it first!"
    end

    def prepare(params={}, &blk)
      @params = OpenStruct.new(default_params.merge(params))
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

    def default_params
      {}
    end
  end
end
