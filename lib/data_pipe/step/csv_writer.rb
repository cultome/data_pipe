require "data_pipe/steppable"

module DataPipe::Step
  class CsvWriter
    include DataPipe::Steppable

    SEPARATOR = ","

    def step_command
      :write_to_csv
    end

    def write_header?
      params.headers.nil? ? false : params.headers
    end

    def iter
      Enumerator.new do |rsp|
        wrote_headers = false

        input.each do |record|
          if write_header? && record.headers? && !wrote_headers
            wrote_headers = true
            line = record.headers.join(SEPARATOR)

            params.stream.puts line
            rsp << line
          end

          line = record.values.join(SEPARATOR)

          params.stream.puts line
          rsp << record
        end
      end
    end
  end
end
