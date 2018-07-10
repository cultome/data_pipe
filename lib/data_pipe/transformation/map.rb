
module DataPipe
  class RecordMap < Transformation
    def iter
      Enumerator.new do |rsp|
        input.each do |record|
          filtered = record.data.select{|k,v| params.include? k}
          rsp << Record.new(filtered, record.params)
        end
      end
    end
  end
end
