
module DataPipe::Step
  class Process
    include DataPipe::Steppable

    def step_command
      :map
    end

    def process(record)
      new_value = fnc.call(record.data)
      Record.new(new_value, record.params)
    end
  end
end
