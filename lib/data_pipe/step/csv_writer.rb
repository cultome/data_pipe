require "data_pipe/stepable"
require "csv"

module DataPipe::Step
  class CsvWriter
    include DataPipe::Stepable

    def step_command
      :write_to_csv
    end

    def iter
      if params.respond_to? :stream
        output = params.stream
        close_output = false
      else
        output = open(params.file, "w")
        close_output = true
      end

      Enumerator.new do |rsp|
        wrote_headers = false

        input.each do |record|
          if write_header? && record.headers? && !wrote_headers
            wrote_headers = true
            line = record.headers.to_csv

            output.puts line
            rsp << line
          end

          line = record.values.to_csv

          output.puts line
          rsp << record
        end

        output.close if close_output
      end
    end

    def default_params
      {
        headers: true
      }
    end

    private

    def write_header?
      params.headers.nil? ? false : params.headers
    end
  end
end
