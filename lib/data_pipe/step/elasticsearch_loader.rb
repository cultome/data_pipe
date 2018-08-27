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
      current_page = 0
      total_docs = 0

      Enumerator.new do |rsp|
        begin
          results = client.search(
            index: params.index,
            body: {
              size: params.batch_size,
              from: current_page,
              query: {
                match_all: {}
              }
            }
          )

          total_docs = results['hits']['total']

          results['hits']['hits'].each do |hit|
            record = Record.new(hit['_source'], headers: true)
            rsp << record
          end

          current_page += params.batch_size
        end while total_docs >= current_page
      end
    end

    def default_params
      {
        url: "http://localhost:9200",
        log_enabled: false,
        batch_size: 100,
      }
    end

    private

    def client
      @client ||= Elasticsearch::Client.new(url: params.url, log: params.log_enabled)
    end
  end
end
