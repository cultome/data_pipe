require "json"

module DataPipe
  class JSONWriter < Writer
    def each
      return input.each unless block_given?

      input.each do |record|
        output.puts record.data.to_json
        yield record
      end
    end
  end
end
