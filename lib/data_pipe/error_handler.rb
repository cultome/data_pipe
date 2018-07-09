
module DataPipe
  class ErrorHandler
    attr_reader :input
    attr_reader :fnc

    def initialize(&blk)
      @fnc = blk
    end

    def set_input(step)
      @input = step
    end

    def process!
      it = input.process!
      loop do
        yield it.next
      rescue StopIteration
        break
      rescue Exception
        next
      end
    end
  end
end
