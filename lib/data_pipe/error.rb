
module DataPipe
  class DataPipeError < StandardError
    attr_reader :record

    def initialize(record)
      @record = record
    end
  end

  class ValidationError < DataPipeError
  end
end
