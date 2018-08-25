require "ostruct"
require "elasticsearch"
require "data_pipe/record"
require "data_pipe/stepable"

module DataPipe::Step
  class ElasticsearchLoader
    include DataPipe::Stepable

    def step_command
      :load_from_elasticsearch
    end

    def iter
      batch_size = 100
      current_page = 0
      total_docs = 0

      Enumerator.new do |rsp|
        begin
          results = client.search(
            index: params.index,
            body: {
              size: batch_size,
              from: current_page,
              query: {
                match_all: {}
              }
            }
          )

          total_docs = results['hits']['total']

          results['hits']['hits'].each do |hit|
            record = Record.new(hit['_source'])
            rsp << record
          end

          current_page += batch_size
        end while total_docs >= current_page
      end
    end

    private

    def client
      @client ||= Elasticsearch::Client.new(url: params.url, log: false)
    end
  end
end
