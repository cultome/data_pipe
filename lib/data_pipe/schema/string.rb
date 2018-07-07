
module DataPipe
  class StringFieldSchema
    attr_reader :params

    def initialize(params)
      @params = params
    end

    def apply(value)
      raise "validation error" unless value.to_s.match? params.format
      value.to_s
    end
  end
end
