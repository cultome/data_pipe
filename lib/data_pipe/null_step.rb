require "data_pipe/step"

module DataPipe
  class NullStep
    include Step

    def iter
      Enumerator.new do |rsp|
        loop do
          rsp << nil
        end
      end
    end
  end
end
