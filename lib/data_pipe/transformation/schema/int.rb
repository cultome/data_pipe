
module DataPipe
  class IntFieldSchema
    def initialize(params)
    end

    def apply(value)
      value.to_i
    end
  end
end
