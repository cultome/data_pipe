require "elasticsearch"
require "data_pipe/stepable"

module DataPipe::Step
  class ElasticsearchWriter
    include DataPipe::Stepable

    def step_command
      :write_to_elasticsearch
    end

    def process(record)
      body = params.record.call(record)
      response = client.index(
        index: params.index,
        type: params.type,
        body: body
      )

      puts "Problems creating [#{record}]" if response["result"] != "created"

      record
    end

    private

    def client
      @client ||= Elasticsearch::Client.new(url: params.url)
    end
  end
end
