# DataPipe

Framework to create data processing pipelines.

## Usage
Lets build a pipeline to export an Elasticsearch index into a CSV file, translating some IDS, filtering some properties and dealing with object properties (nested).

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

| param       | type     | required? | description             | default               |
|-------------|----------|-----------|-------------------------|-----------------------|
| index       | `String` | true      | Name of the ES index    |                       |
| url         | `String` | false     | URL of the ES endpoint  | http://localhost:9200 |
| log_enabled | `Boolean`| false     | Should display ES logs? | false                 |
| batch_size  | `Int`    | false     | Size of the batches     | 100                   |

#### load_from_csv
Loads data from a CSV file or stream.

```ruby
  load_from_csv file: "employees.csv"
```

| param   | type     | required? | description                         | default |
|---------|----------|-----------|-------------------------------------|---------|
| file    | `String` | true      | File path of the data file          |         |
| headers | `Boolean`| false     | Data contains headers in first row? | true    |

#### load_from_json
Loads data from a JSON file or stream.

```ruby
  load_from_json file: "service_response.json"
```

| param   | type                | required? | description                    | default |
|---------|---------------------|-----------|--------------------------------|---------|
| file    | `String`            | false *   | File path of the data file     |         |
| stream  | respond to `#read`  | false *   | Object from where to read data |         |
> _*_ one of `file` or `stream` are required

#### load_from_xlsx
Loads data from a XLSX file.

```ruby
  load_from_xlsx(
    stream: "state_stats.xlsx",
    sheet: "January",
    first_data_row: 3,
  )
```

| param           | type    | required? | description                        | default |
|-----------------|---------|-----------|------------------------------------|---------|
| file            | `String`  | true      | File path of the data file         |         |
| sheet           | `Int`     | false     | The position of the sheet to parse | 0       |
| headers         | `Boolean` | false     | Data contains headers?             | true    |
| header_row      | `Int`     | false     | ID of the row where headers are    | 1       |
| first_data_row  | `Int`     | false     | ID of the row where start starts   | 2       |


#### write_to_csv
Writes to a file or stream in CSV format.

```ruby
  write_to_csv file: "results.csv"
```

| param   | type                | required? | description                    | default |
|---------|---------------------|-----------|--------------------------------|---------|
| file    | `String`            | false *   | File path of the file to write |         |
| stream  | respond to `#puts`  | false *   | Object where to write data     |         |
| headers | `Boolean`           | false     | Should write headers?          | true    |
> _*_ one of `file` or `stream` are required

#### write_to_json
Writes to a file or stream in JSON format.

```ruby
  write_to_json stream: output
```

| param   | type                | required? | description                    | default |
|---------|---------------------|-----------|--------------------------------|---------|
| file    | `String`            | false *   | File path of the file to write |         |
| stream  | respond to `#puts`  | false *   | Object where to write data     |         |
> _*_ one of `file` or `stream` are required

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

| param   | type              | required? | description                                           | default               |
|---------|-------------------|-----------|-------------------------------------------------------|-----------------------|
| index   | `String`          | true      | Name of the index for insertion                       |                       |
| type    | `String`          | true      | Name of the document type                             |                       |
| record  | `lamda` or `Proc` | true      | Function to return the body of the document to insert |                       |
| url     | `String`          | false     | URL of the ES endpoint                                | http://localhost:9200 |

#### tap
Visits the records but does nothing with the result.

```ruby
  tap do |record|
    log("[*] Processing #{record}...")
  end
```

| param   | receives | returns   | required? | description       | default |
|---------|----------|-----------|-----------|-------------------|---------|
| &block  | `Record` |           | true      | Interest function |         |

#### map
Pass downstream the resulting record or hash.
If nil is returned, the complete record is filter out.

```ruby
  map do |record|
    record.data.merge name: "Supervidor"
  end
```

| param   | receives | returns            | required? | description                                                  | default |
|---------|----------|--------------------|-----------|--------------------------------------------------------------|---------|
| &block  | `Record` | `Record` or `Hash` | true      | Function to transform the data and return `Record` or `Hash` |         |

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

| param   | receives              | returns   | required? | description                 | default |
|---------|-----------------------|-----------|-----------|-----------------------------|---------|
| &block  | `Exception`, `Record` |           | true      | Function for error handling |         |

#### apply_schema
Pass the records for a schema validation. This can check types and formats and do some basic cleaning.

The implemented fields are:

| name           |  param    | type       | required | description                                                                  |
|----------------|-----------|------------|----------|------------------------------------------------------------------------------|
| `string_field` | default   | `String`   | false    | Default value to use when empty from datasource                              |
|                | required  | `Boolean`  | false    | Mark the value as required. Empty values will fail                           |
|                | format    | `String`   | false    | Regexp used to validate the value content                                    |
|                | titlecase | `Boolean`  | false    | Converts the value to `titlecase` (first letter upcased, downcase the rest)  |
| `int_field`    | default   | `Int`      | false    | Default value to use when empty from datasource                              |
|                | required  | `Boolean`  | false    | Mark the value as required. Empty values will fail                           |
|                | min       | `Int`      | false    | Validates the lower value of the data                                        |
|                | max       | `Int`      | false    | Validates the upper value of the data                                        |
| `float_field`  | default   | `Float`    | false    | Default value to use when empty from datasource                              |
|                | required  | `Boolean`  | false    | Mark the value as required. Empty values will fail                           |
|                | min       | `Float`    | false    | Validates the lower value of the data                                        |
|                | max       | `Float`    | false    | Validates the upper value of the data                                        |
| `date_field`   | default   | `String` * | false    | Default value to use when empty from datasource                              |
|                | format    | `String`   | false    | Regexp used to validate the value content                                    |
|                | required  | `Boolean`  | false    | Mark the value as required. Empty values will fail                           |
|                | past_only | `Boolean`  | false    | Validates that the resulting date is in the past (before or equals to `now`) |

```ruby
  apply_schema definition: {
    "name" => string_field(format: /^[A-Z]/, required: true),
    "age" => int_field(min: 1, max: 100),
    "account_balance" => float_field(min: 2, max: 10),
    "birthdate" => date_field(format: "%Y-%m-%d"),
  }
```

| param      | type | required? | description       | default |
|------------|------|-----------|-------------------|---------|
| definition | Hash | true      | Schema definition |         |

#### select
Using a predicate function it selects/pass records that makes the predicate `true`.

```ruby
  select do |record|
    record.data["age"] > 18
  end
```

| param   | receives | returns | required? | description                                    | default |
|---------|----------|---------|-----------|------------------------------------------------|---------|
| &block  | `Record` | `Boolean` true      | Predicate to decide if keep or drop the record |         |

#### filter_properties
Select or reject record properties, so resulting record only contains the selected or no-rejected properties.

```ruby
  filter_properties exclude: true, keys: ["account_balance", "age"]
```

| param   | type              | required? | description                           | default |
|---------|-------------------|-----------|---------------------------------------|---------|
| keys    | `Array`[`String`] | true      | The properties to operate on          |         |
| exclude | `Boolean`         | false     | Should exclude or include given keys? | false   |

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

 * Agregar validacion para parametros requeridos
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
