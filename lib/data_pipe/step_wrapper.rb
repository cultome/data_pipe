require "data_pipe/iterable"
require "data_pipe/inputable"

module DataPipe
  class StepWrapper
    include Iterable
    include Inputable

    attr_reader :next_step
    attr_reader :prev_step
    attr_reader :prev_step_iter

    def initialize(prev_step, next_step)
      @prev_step = prev_step
      @prev_step_iter = prev_step.iter
      @next_step = next_step
    end

    def next
      prev_step_iter.next
    end

    def iter
      Enumerator.new do |rsp|
        loop do
          value = prev_step_iter.next
          puts "[*] #{prev_step.class} => #{next_step.class} [#{value}]"
          rsp << value
        end
      end
    end
  end
end
