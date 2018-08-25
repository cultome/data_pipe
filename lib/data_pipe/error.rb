require "ostruct"

module DataPipe::Error
  class DataPipeError < StandardError
    attr_reader :record, :original_error

    def initialize(record, error=nil)
      @record = record
      @original_error = error

      if error.is_a? String
        @original_error = OpenStruct.new(
          message: error,
        )
      end
    end

    def to_s
      "Oops! #{original_error.message} [#{record}]"
    end
  end

  class ValidationError < DataPipeError
  end

  class ConfigurationError < DataPipeError
  end
end
