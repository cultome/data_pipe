
module DataPipe
  class CSVWriter
    attr_reader :output
    attr_reader :input

    SEPARATOR = ","

    def initialize(output)
      @output = output
    end

    def set_input(step)
      @input = step
    end

    def each
      input.each{|record| yield record }
    end

    def process!
      each{|record| output.puts record.values.join(SEPARATOR) }
    end
  end
end
