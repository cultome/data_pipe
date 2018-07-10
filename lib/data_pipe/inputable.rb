
module DataPipe
  module Inputable
    attr_reader :input

    def set_input(input)
      @input = input
      self
    end
  end
end
