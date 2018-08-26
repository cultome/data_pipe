require "data_pipe/record"
require "data_pipe/stepable"

module DataPipe::Step
  class Tap
    include DataPipe::Stepable

    def step_command
      :tap
    end

    def process(record)
      fnc.call(record)
      record
    end
  end
end
