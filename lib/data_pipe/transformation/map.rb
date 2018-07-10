
module DataPipe
  class RecordMap < Transformation
    def each
      return input.each unless block_given?

      input.each do |record|
        filtered = record.data.select{|k,v| params.include? k}
        yield Record.new(filtered, record.params)
      end
    end
  end
end
