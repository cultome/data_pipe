require "ostruct"
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
      Enumerator.new do |rsp|
        JSON.load(open(params.stream)).each do |obj|
          rsp << Record.new(obj)
        end
      end
    end
  end
end
