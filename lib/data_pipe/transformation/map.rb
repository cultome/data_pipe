
module DataPipe
  class RecordMap < Transformation
    def process(record)
      filtered = record.data.select{|k,v| params.include? k}
      Record.new(filtered, record.params)
    end
  end
end
