
module DataPipe::Step
  class Map
    include DataPipe::Stepable

    def step_command
      :map
    end

    def process(record)
      fnc.call(record)
    end
  end
end
