require "ostruct"
require "json"
require "data_pipe/record"
require "data_pipe/step"

module DataPipe::Loader
  class JSONLoader
    include DataPipe::Step

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
