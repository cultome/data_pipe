require "data_pipe/steppable"

module DataPipe::Step
  class ErrorHandler
    include DataPipe::Stepable

    attr_reader :fnc

    def step_command
      :handle_error
    end

    def iter
      Enumerator.new do |rsp|
        it = input.each
        loop do
          value = it.next
          rsp << value
        rescue StopIteration
          break
        rescue Exception => err
          fnc.call(err, value)
        end
      end
    end
  end
end
