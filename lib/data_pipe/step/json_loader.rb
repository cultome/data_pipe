require "json"
require "data_pipe/record"
require "data_pipe/stepable"

module DataPipe::Step
  class JsonLoader
    include DataPipe::Stepable

    def step_command
      :load_from_json
    end

    def iter
      if params.respond_to? :stream
        input_source = params.stream.read
      else
        input_source = open(params.file, "r").read
      end

      Enumerator.new do |rsp|
        JSON.load(input_source).each do |obj|
          rsp << Record.new(obj, headers: true)
        end
      end
    end
  end
end
