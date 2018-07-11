require "data_pipe/step"

module DataPipe
  class NullStep
    include Step

    def process(record)
      Record.new({})
    end
  end
end
