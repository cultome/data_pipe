require "elasticsearch"
require "json"

RSpec.describe "Elasticsearch" do
  context "with elasticsearch instance running" do
    before :each do
      `./spec/services/es_init`
      Elasticsearch::Client.new(url: "http://localhost:9200").indices.flush
    end

    it "loads all documents from an index" do
      output = StringIO.new

      DataPipe.create do
        log_to StringIO.new

        load_from_elasticsearch index: "data_pipe"
        write_to_json stream: output, headers: true
      end.process!

      expect(output.string).to eq <<-TEXT
{"one":"data_pipe","two":"data pipe","three":42,"four":"2018-08-24 21:41:22"}
      TEXT
    end

    it "insert documents in an index" do
      DataPipe.create do
        log_to StringIO.new

        load_from_elasticsearch index: "data_pipe"

        write_to_elasticsearch(
          index: "backup",
          type: "data",
          record: ->(record) {{
            "five": record.data["one"],
            "six": record.data["two"],
            "seven": record.data["three"],
            "eight": record.data["four"],
          }}
        )
      end.process!

      client.indices.flush
      results = client.search(
        index: "backup",
        type: "data",
        body: {
          query: {
            match_all: {}
          }
        }
      )

      result = results['hits']['hits'].reduce([]) do |acc,hit|
        acc.push hit['_source'].to_json
        acc
      end.join("\n")

      expected = '{"five":"data_pipe","six":"data pipe","seven":42,"eight":"2018-08-24 21:41:22"}'
      expect(result).to eq expected
    end

    it "writes plain documents to CSV" do
      output = StringIO.new

      DataPipe.create do
        log_to StringIO.new

        load_from_elasticsearch index: "data_pipe"
        write_to_csv stream: output, headers: true
      end.process!

      expect(output.string).to eq <<-TEXT
one,two,three,four
data_pipe,data pipe,42,2018-08-24 21:41:22
      TEXT
    end

    it "writes nested documents to CSV" do
      output = StringIO.new

      DataPipe.create do
        log_to StringIO.new

        load_from_elasticsearch index: "nested"
        flatten
        write_to_csv stream: output, headers: true
      end.process!

      expect(output.string).to eq <<-TEXT
nine.nest_one,nine.nest_two,ten
data_pipe,one|two,three|four
      TEXT
    end

    def client
      @client ||= Elasticsearch::Client.new(url: "http://localhost:9200")
    end
  end
end
