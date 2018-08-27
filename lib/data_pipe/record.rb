require "ostruct"

module DataPipe
  class Record
    attr_reader :data
    attr_reader :params

    def initialize(data, opts={})
      @data = data
      @params = OpenStruct.new(opts)
    end

    def values
      data.values
    end

    def headers
      data.keys
    end

    def headers?
      params.headers.nil? ? false : params.headers
    end

    def to_s
      "#{data} [#{params}]"
    end
  end
end
