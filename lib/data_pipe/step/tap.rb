require "data_pipe/record"
require "data_pipe/steppable"

module DataPipe::Step
  class Tap
    include DataPipe::Steppable

    def step_command
      :tap
    end

    def process(record)
      fnc.call(record.data)
      record
    end
  end
end
