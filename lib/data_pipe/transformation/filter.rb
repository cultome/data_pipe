
module DataPipe
  class RecordFilter < Transformation
    def iter
      Enumerator.new do |rsp|
        input.each do |record|
          should_keep = fnc.call(record.data)
          rsp << record if should_keep
        end
      end
    end
  end
end
