
module DataPipe
  class RecordProcess < Transformation
    attr_reader :fnc

    def initialize(&blk)
      @fnc = blk
    end

    def each
      return input.each unless block_given?

      input.each do |record|
        new_value = fnc.call(record.data)
        yield Record.new(new_value, record.params)
      end
    end
  end
end
