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
        if row.respond_to? :headers
          yield row.to_h
        else
          yield ((0...row.size).zip(row)).to_h
        end
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
