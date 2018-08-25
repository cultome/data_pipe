require "data_pipe/steppable"
require "csv"

module DataPipe::Step
  class CsvWriter
    include DataPipe::Stepable

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
            line = record.headers.to_csv

            params.stream.puts line
            rsp << line
          end

          line = record.values.to_csv

          params.stream.puts line
          rsp << record
        end
      end
    end
  end
end
