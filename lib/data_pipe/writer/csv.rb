
module DataPipe
  class CSVWriter
    attr_reader :params
    attr_reader :output
    attr_reader :input

    SEPARATOR = ","

    def initialize(output, params)
      @params = params
      @output = output
    end

    def write_header?
      params.headers.nil? ? false : params.headers
    end

    def set_input(step)
      @input = step
    end

    def each
      input.each{|record| yield record }
    end

    def process!
      wrote_headers = false
      each do |record|
        if write_header? && record.headers? && !wrote_headers
          wrote_headers = true
          output.puts record.headers.join(SEPARATOR)
        end
        output.puts record.values.join(SEPARATOR)
      end
    end
  end
end
