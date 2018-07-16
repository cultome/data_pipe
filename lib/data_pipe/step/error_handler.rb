require "data_pipe/steppable"

module DataPipe::Step
  class ErrorHandler
    include DataPipe::Steppable

    attr_reader :fnc

    def self.pipe_command
      :error_handler
    end

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
