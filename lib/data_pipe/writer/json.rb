require "json"

module DataPipe
  class JSONWriter < Writer
    def process!
      return input.process unless block_given?

      input.process! do |record|
        output.puts record.data.to_json
      end
    end
  end
end
