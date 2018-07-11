
module DataPipe::Transformation
  class RecordProcess < Transformation
    def process(record)
      new_value = fnc.call(record.data)
      Record.new(new_value, record.params)
    end
  end
end
