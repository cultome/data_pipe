
module DataPipe
  class FieldSchema
    attr_reader :params

    def initialize(params)
      @params = params
    end

    def apply(value)
      raise "must implement it first!"
    end
  end
end
