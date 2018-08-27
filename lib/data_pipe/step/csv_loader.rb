require "csv"
require "data_pipe/record"
require "data_pipe/stepable"

module DataPipe::Step
  class CsvLoader
    include DataPipe::Stepable

    def step_command
      :load_from_csv
    end

    def iter
      Enumerator.new do |rsp|
        loader_params = {
          headers: params.headers.nil? ? false : params.headers
        }
        CSV.foreach(params.stream, loader_params) do |row|
          record = get_record(row)
          rsp << record
        end
      end
    end

    private

    def get_record(row)
      if row.respond_to? :headers
        record = Record.new(row.to_h, headers: true)
      else
        data = (0...row.size).map(&:to_s).zip(row)
        record = Record.new(data.to_h, headers: false)
      end

      return record
    end
  end
end
