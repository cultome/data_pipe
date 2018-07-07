
module DataPipe
  class FloatFieldSchema
    attr_reader :params

    def initialize(params)
      @params = params
    end

    def apply(value)
      fl_val = value.to_f
      raise "validation error" unless fl_val >= params.min && fl_val <= params.max
      fl_val
    rescue
      raise "validation error"
    end
  end
end
