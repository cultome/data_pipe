require "data_pipe/iterable"
require "data_pipe/inputable"

module DataPipe
  class StepWrapper
    include Iterable
    include Inputable

    attr_reader :step

    def initialize(step)
      @step = step
    end

    def iter
      Enumerator.new do |rsp|
        value = input.next
        puts "[#{step.class}] #{value}"
        rsp << value
      end
    end
  end
end
