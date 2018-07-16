require "data_pipe/record"
require 'data_pipe/step/schema/date'
require 'data_pipe/step/schema/string'
require 'data_pipe/step/schema/int'
require 'data_pipe/step/schema/float'
require "data_pipe/steppable"

module DataPipe::Step::Schema
  class Schema
    include DataPipe::Steppable

    attr_reader :schema

    def initialize(schema)
      @schema = schema
    end

    def process(record)
      new_data = apply_schema(record)
      new_record = Record.new(new_data, record.params)
      new_record
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
