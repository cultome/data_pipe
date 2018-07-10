require "json"

module DataPipe
  class JSONWriter < Writer
    def iter
      Enumerator.new do |rsp|
        input.each do |record|
          output.puts record.data.to_json
          rsp << record
        end
      end
    end
  end
end
