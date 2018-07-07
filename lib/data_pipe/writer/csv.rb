
module DataPipe
  class CSVWriter < Writer

    SEPARATOR = ","

    def write_header?
      params.headers.nil? ? false : params.headers
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
