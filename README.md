# DataPipe

Framework to create data processing pipelines.

## Usage

Lets say we need to export an Elasticsearch's index into a CSV file.

```ruby
DataPipe.create do
  load_from_elasticsearch(          # Loads batches of docs from ES index
    index: "open_source_data",      # and pass it down the pipeline
    url: "https://localhost:9200",
  )

  write_to_csv file: "index.csv", headers: true
end.process!
```

 * CsvLoader
 * CsvWriter
 * ElasticsearchLoader
 * ElasticsearchWriter
 * ErrorHandler
 * Filter
 * JsonLoader
 * JsonWriter
 * Map
 * Process
 * Schema
 * Tap
 * XlsxLoader

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'data_pipe'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install data_pipe

## TODO

 * El paso flatten es optimista en cuanto a la estructura homogenea de los records
 * Agregar logica para eliminar datos mapeados que regresen nil
 * Improve naming of the transformations steps
 * Filter by date criterias (in general operate with date data)
 * Add sorting step
 * Associate labels to headers/properties
 * Validate JSON structure
 * Process by criteria (if passes a test process it)
 * Add loaders for databases
 * Improve processing information (inside pipeline)
 * Change root property (for JSON loader)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/data_pipe.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
