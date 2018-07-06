require "json"

module DataPipe
  class JSONWriter
    attr_reader :params
    attr_reader :output
    attr_reader :input

    def initialize(output, params)
      @params = params
      @output = output
    end

    def set_input(step)
      @input = step
    end

    def each
      input.each{|record| yield record }
    end

    def process!
      each do |record|
        output.puts record.data.to_json
      end
    end
  end
end
