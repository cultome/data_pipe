require "ostruct"
require "csv"
require "data_pipe/record"
require "data_pipe/step"

module DataPipe
  class CSVLoader
    include Step

    attr_reader :resource_path
    attr_reader :params

    EMPTY_PARAMS = OpenStruct.new({})

    def initialize(resource_path, params=EMPTY_PARAMS)
      @resource_path = resource_path
      @params = {
        headers: params.headers.nil? ? false : params.headers
      }
    end

    def iter
      Enumerator.new do |rsp|
        CSV.foreach(resource_path, params) do |row|
          record = get_record(row)
          rsp << record
        end
      end
    end

    private

    def get_record(row)
      if row.respond_to? :headers
        props = OpenStruct.new(headers: true)
        record = Record.new(row.to_h, props)
      else
        data = (0...row.size).map(&:to_s).zip(row)
        props = OpenStruct.new(headers: false)
        record = Record.new(data.to_h, props)
      end

      return record
    end
  end
end
