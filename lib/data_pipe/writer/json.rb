require "json"

module DataPipe
  class JSONWriter < Writer
    def process(record)
      output.puts record.data.to_json
      record
    end
  end
end
