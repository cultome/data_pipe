
module DataPipe
  class RecordProcess < Transformation
    attr_reader :fnc

    def initialize(&blk)
      @fnc = blk
    end

    def process!
      input.process! do |record|
        new_value = fnc.call(record.data)
        yield Record.new(new_value, record.params)
      end
    end
  end
end
