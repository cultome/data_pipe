
module DataPipe
  class CSVWriter < Writer

    SEPARATOR = ","

    def write_header?
      params.headers.nil? ? false : params.headers
    end

    def each
      return input.each unless block_given?

      wrote_headers = false
      input.each do |record|
        if write_header? && record.headers? && !wrote_headers
          wrote_headers = true
          line = record.headers.join(SEPARATOR)

          output.puts line
          yield line
        end

        line = record.values.join(SEPARATOR)

        output.puts line
        yield record
      end
    end
  end
end
