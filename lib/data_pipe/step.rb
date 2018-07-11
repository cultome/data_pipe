
module DataPipe
  module Step
    include Enumerable

    attr_reader :input

    def set_input(input)
      @input = input
      self
    end

    def each
      return iter unless block_given?
      iter.each{|record| yield record }
    end
  end
end
