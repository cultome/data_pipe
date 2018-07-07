require "date"

module DataPipe
  class DateFieldSchema
    attr_reader :params

    def initialize(params)
      @params = params
    end

    def apply(value)
      Date.strptime(value, params.format)
    rescue
      raise "validation error"
    end
  end
end
