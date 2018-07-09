
module DataPipe
  class RecordFilter < Transformation
    attr_reader :fnc

    def initialize(&blk)
      @fnc = blk
    end

    def process!
      return input.process! unless block_given?

      input.process! do |record|
        should_keep = fnc.call(record.data)
        yield record if should_keep
      end
    end
  end
end
