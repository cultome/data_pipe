require "data_pipe/steppable"

module DataPipe
  class NullStep
    include DataPipe::Steppable

    def process(record)
      Record.new({})
    end
  end
end
