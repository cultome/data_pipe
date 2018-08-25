
module DataPipe::Step
  class Filter
    include DataPipe::Stepable

    def step_command
      :filter_records
    end

    def process(record)
      fnc.call(record.data) ? record : nil
    end
  end
end
