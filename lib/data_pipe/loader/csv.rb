require "data_pipe/record"
require "ostruct"
require "csv"

module DataPipe
  class CSVLoader
    attr_reader :resource_path
    attr_reader :params
    attr_reader :input

    def initialize(resource_path, params)
      @resource_path = resource_path
      @params = {
        headers: params.headers.nil? ? false : params.headers
      }
    end

    def each
      return CSV.read(resource_path, params).map{|r| get_record(r) }.each unless block_given?

      CSV.foreach(resource_path, params) do |row|
        record = get_record(row)
        yield record
      end
    end

    def set_input(step)
      @input = step
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
