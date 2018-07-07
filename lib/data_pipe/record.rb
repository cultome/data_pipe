
module DataPipe
  class Record
    attr_reader :data
    attr_reader :params

    def initialize(data, opts={})
      @data = data
      @params = opts
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
  end
end