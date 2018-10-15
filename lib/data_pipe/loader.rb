require "data_pipe/error"

module DataPipe
  class Loader
    def next
      raise DataPipe::NoMoreElements.new
    end
  end
end
