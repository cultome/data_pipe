
module DataPipe::Step
  class Select
    include DataPipe::Stepable

    def step_command
      :select
    end

    def process(record)
      fnc.call(record) ? record : nil
    end
  end
end
