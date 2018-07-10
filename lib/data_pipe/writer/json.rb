require "json"

module DataPipe
  class JSONWriter < Writer
    def each
      return input.process unless block_given?

      input.each do |record|
        output.puts record.data.to_json
      end
    end
  end
end
