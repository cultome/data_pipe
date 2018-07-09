
module DataPipe
  class RecordMap < Transformation
    def process!
      return input.process! unless block_given?

      input.process! do |record|
        filtered = record.data.select{|k,v| params.include? k}
        yield Record.new(filtered, record.params)
      end
    end
  end
end
