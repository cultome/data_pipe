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
      CSV.foreach(resource_path, params) do |row|
        rec = if row.respond_to? :headers
                props = OpenStruct.new(headers: true)
          Record.new(row.to_h, props)
        else
          data = (0...row.size).map(&:to_s).zip(row)
          props = OpenStruct.new(headers: false)
          Record.new(data.to_h, props)
        end

        yield rec
      end
    end

    def set_input(step)
      @input = step
    end

    def process!
      each do |row_hash|
        yield row_hash
      end
    end
  end
end
