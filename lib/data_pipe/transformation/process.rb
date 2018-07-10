
module DataPipe
  class RecordProcess < Transformation
    def iter
      Enumerator.new do |rsp|
        input.each do |record|
          new_value = fnc.call(record.data)
          rsp << Record.new(new_value, record.params)
        end
      end
    end
  end
end
