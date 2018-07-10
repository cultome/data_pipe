
module DataPipe
  class RecordProcess < Transformation
    def each
      return input.each unless block_given?

      input.each do |record|
        new_value = fnc.call(record.data)
        yield Record.new(new_value, record.params)
      end
    end
  end
end
