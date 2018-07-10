require "data_pipe/iterable"
require "data_pipe/inputable"

module DataPipe
  class ErrorHandler
    include Iterable
    include Inputable

    attr_reader :fnc

    def initialize(&blk)
      @fnc = blk
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
