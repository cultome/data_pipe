require "data_pipe/stepable"

module DataPipe
  class NullStep
    include DataPipe::Stepable

    def process(record)
      Record.new({})
    end
  end
end
