
module DataPipe
  class RecordFilter < Transformation
    def each
      return input.each unless block_given?

      input.each do |record|
        should_keep = fnc.call(record.data)
        yield record if should_keep
      end
    end
  end
end
