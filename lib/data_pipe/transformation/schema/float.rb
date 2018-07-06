
module DataPipe
  class FloatFieldSchema
    def initialize(params)
    end

    def apply(value)
      value.to_f
    end
  end
end
