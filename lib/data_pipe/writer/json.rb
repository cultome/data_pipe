require "json"

module DataPipe
  class JSONWriter < Writer
    def process!
      each do |record|
        output.puts record.data.to_json
      end
    end
  end
end
