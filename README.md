# DataPipe

Framework to create data processing pipelines.

## Usage
Lets build a pipeline to export an Elasticsearch index into a CSV file, translating some IDS, filtering some properties and dealing with object properties.

```ruby
DataPipe.create do
  # this first step gets data from `open_source_data` index
  load_from_elasticsearch index: "open_source_data"

  # this step deals with the nested properties,
  # creates plain keys for objects and arrays
  flatten

  # with this, you can change anything you need and
  # return another record that will be used downstream
  map do |record|
    record.data['location.municipality_id'] = locs[record.data['location.municipality_id']]
    record
  end

  # from the record, filter out (`exclude: true`) the named properties
  filter_properties exclude: true, keys: [
    "created_at",
    "updated_at",
  ]

  # finally write the resulting records in a CSV format
  write_to_csv file: "index.csv"
end.process!
```

### Steps
These are the available steps currently implemented:

#### load_from_elasticsearch
Loads data from an Elasticsearch database.

```ruby
  load_from_elasticsearch index: "data_pipe"
```

#### load_from_csv
Loads data from a CSV file or stream.

```ruby
  load_from_csv file: "employees.csv", headers: false
```

#### load_from_json
Loads data from a JSON file or stream.

```ruby
  load_from_json file: "service_response.json"
```

#### load_from_xlsx
Loads data from a XLSX file.

```ruby
  load_from_xlsx(
    stream: "state_stats.xlsx",
    sheet: "January",
    first_data_row: 3,
  )
```

#### write_to_csv
Writes to a file or stream in CSV format.

```ruby
  write_to_csv file: "results.csv"
```

#### write_to_json
Writes to a file or stream in JSON format.

```ruby
  write_to_json stream: output
```

#### write_to_elasticsearch
Writes to a Elasticsearch database index.

The `record` function is used to format the document to be inserted.

```ruby
  write_to_elasticsearch(
    index: "backup",
    type: "data",
    url: "http://localhost:9200",
    record: ->(record) {{
      "five": record.data["one"],
      "six": record.data["two"],
      "seven": record.data["three"],
      "eight": record.data["four"],
    }}
  )
```

#### tap
Visits the records but does nothing with the result.

```ruby
  tap do |record|
    log("[*] Processing #{record}...")
  end
```

#### map
Pass downstream the resulting record or hash.
If nil is returned, the complete record is filter out.

```ruby
  map do |record|
    record.data.merge name: "Supervidor"
  end
```

#### flatten
Give object or array property value, this step converts them to a scalar value.

For example if we have this data:

```json
{
  "name": "cultome",
  "address": {
    "street": "Calle 1234",
    "state": "CDMX",
    "country": "Mexico"
  },
  "hobbies": ["watch tv", "programming"],
}
```

`flatten` will turn it into this:

```json
{
  "name": "cultome",
  "address.street": "Calle 1234",
  "address.state": "CDMX",
  "address.country": "Mexico",
  "hobbies": "watch tv|programming",
}
```

This step is appropiated when converting JSON data into a CSV format

```ruby
  flatten
```

#### handle_error
This error handler allows us to catch expected error and continue with the processing.
:fire: For the nature of the pipeline, the error handler should be declared before the problematic step(s) :fire:

```ruby
  handle_error do |err,record|
    log.error("[-] Error with record [#{record}]: #{err}")
  end
```

#### apply_schema
Pass the records for a schema validation. This can check types and formats and do some basic cleaning.

The implemented fields are:
 * string_field
 * int_field
 * float_field
 * date_field

```ruby
  apply_schema definition: {
    "name" => string_field(format: /^[A-Z]/, required: true),
    "age" => int_field(min: 1, max: 100),
    "account_balance" => float_field(min: 2, max: 10),
    "birthdate" => date_field(format: "%Y-%m-%d"),
  }
```

#### filter_records
Using a predicate function it selects/pass records that makes the predicate `true`.

```ruby
  filter_records do |record|
    record.data["age"] > 18
  end
```

#### filter_properties
Select or reject record properties, so resulting record only contains the selected or no-rejected properties.

```ruby
  filter_properties exclude: true, keys: ["account_balance", "age"]
```



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

 * Remove the need to include the module
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
