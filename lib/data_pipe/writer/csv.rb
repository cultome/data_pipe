
module DataPipe
  class CSVWriter < Writer

    SEPARATOR = ","

    def write_header?
      params.headers.nil? ? false : params.headers
    end

    def process!
      wrote_headers = false
      input.process! do |record|
        if write_header? && record.headers? && !wrote_headers
          wrote_headers = true
          line = record.headers.join(SEPARATOR)

          output.puts line
          yield line if block_given?
        end

        line = record.values.join(SEPARATOR)

        output.puts line
        yield line if block_given?
      end
    end
  end
end
