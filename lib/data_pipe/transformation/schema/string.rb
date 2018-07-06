
module DataPipe
  class StringFieldSchema
    def initialize(params)
    end

    def apply(value)
      value.to_s
    end
  end
end
