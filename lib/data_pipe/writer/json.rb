require "json"

module DataPipe
  class JSONWriter < Writer
    def process!
      input.process! do |record|
        output.puts record.data.to_json
      end
    end
  end
end
