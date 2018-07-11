require "data_pipe/step"

module DataPipe
  class ErrorHandler
    include Step

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
        rescue Exception => err
          fnc.call(err)
        end
      end
    end
  end
end
