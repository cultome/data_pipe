require "data_pipe/record"
require 'data_pipe/schema/date'
require 'data_pipe/schema/string'
require 'data_pipe/schema/int'
require 'data_pipe/schema/float'

module DataPipe
  class Schema
    attr_reader :schema
    attr_reader :input

    def initialize(schema)
      @schema = schema
    end

    def set_input(input)
      @input = input
    end

    def process!
      return input.process! unless block_given?

      input.process! do |record|
        new_data = apply_schema(record)
        new_record = Record.new(new_data, record.params)
        yield new_record
      end
    end

    private

    def apply_schema(record)
      record.data.reduce({}) do |acc,(key,value)|
        acc[key] = transform_field(key, value, record)
        acc
      end
    end

    def transform_field(field, value, record)
      if schema.has_key? field
        schema[field].apply(value, record)
      else
        value
      end
    end
  end
end
