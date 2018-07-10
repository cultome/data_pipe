require "data_pipe/iterable"

module DataPipe
  class ErrorHandler
    include Iterable

    attr_reader :input
    attr_reader :fnc

    def initialize(&blk)
      @fnc = blk
    end

    def set_input(step)
      @input = step
      self
    end

    def iter
      Enumerator.new do |rsp|
        it = input.each
        loop do
          rsp << it.next
        rescue StopIteration
          break
        rescue Exception
          next
        end
      end
    end
  end
end
