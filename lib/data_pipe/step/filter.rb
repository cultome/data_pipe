
module DataPipe::Step
  class Filter
    include DataPipe::Steppable

    def pipe_command
      :filter_records
    end

    def process(record)
      fnc.call(record.data) ? record : nil
    end
  end
end
