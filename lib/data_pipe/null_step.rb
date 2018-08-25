require "data_pipe/steppable"

module DataPipe
  class NullStep
    include DataPipe::Stepable

    def process(record)
      Record.new({})
    end
  end
end
