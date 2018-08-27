require "data_pipe/record"

module DataPipe::Step
  class Map
    include DataPipe::Stepable

    def step_command
      :map
    end

    def process(record)
      result = fnc.call(record)
      if result.is_a? Record
        result
      elsif result.is_a? Hash
        Record.new(result, record.params)
      end
    end
  end
end
