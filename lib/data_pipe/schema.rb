require "data_pipe/record"
require 'data_pipe/schema/date'
require 'data_pipe/schema/string'
require 'data_pipe/schema/int'
require 'data_pipe/schema/float'

module DataPipe
  class SchemaTransformation
    attr_reader :schema
    attr_reader :input

    def initialize(schema)
      @schema = schema
    end

    def set_input(input)
      @input = input
    end

    def each
      input.each do |record|
        new_data = apply(record.data)
        new_record = Record.new(new_data, record.params)
        yield new_record
      end
    end

    alias :process! :each

    private

    def apply(data)
      data.reduce({}) do |acc,(key,value)|
        acc[key] = transform_field(key, value)
        acc
      end
    end

    def transform_field(field, value)
      if schema.has_key? field
        schema[field].apply(value)
      else
        value
      end
    end
  end
end
