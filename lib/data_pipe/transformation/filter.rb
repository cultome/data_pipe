
module DataPipe::Transformation
  class RecordFilter < Transformation
    def process(record)
      fnc.call(record.data) ? record : nil
    end
  end
end
