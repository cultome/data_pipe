require "data_pipe/steppable"

module DataPipe::Step
  class ErrorHandler
    include DataPipe::Steppable

    attr_reader :fnc

    def pipe_command
      :handle_error
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
