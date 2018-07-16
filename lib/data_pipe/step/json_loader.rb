require "ostruct"
require "json"
require "data_pipe/record"
require "data_pipe/steppable"

module DataPipe::Step
  class JSONLoader
    include DataPipe::Steppable

    attr_reader :resource_path
    attr_reader :params

    EMPTY_PARAMS = OpenStruct.new({})

    def initialize(resource_path, params=EMPTY_PARAMS)
      @resource_path = resource_path
      @params = params
    end

    def iter
      Enumerator.new do |rsp|
        JSON.load(open(resource_path)).each do |obj|
          rsp << Record.new(obj)
        end
      end
    end
  end
end
