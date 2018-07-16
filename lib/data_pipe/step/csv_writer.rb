require "data_pipe/steppable"

module DataPipe::Step
  class CsvWriter
    include DataPipe::Steppable

    attr_reader :params
    attr_reader :output

    EMPTY_PARAMS = OpenStruct.new({})
    SEPARATOR = ","

    def initialize(output, params=EMPTY_PARAMS)
      @params = params
      @output = output
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

            output.puts line
            rsp << line
          end

          line = record.values.join(SEPARATOR)

          output.puts line
          rsp << record
        end
      end
    end
  end
end
