require "data_pipe/record"
require 'data_pipe/schema/date'
require 'data_pipe/schema/string'
require 'data_pipe/schema/int'
require 'data_pipe/schema/float'
require "data_pipe/iterable"
require "data_pipe/inputable"

module DataPipe
  class Schema
    include Iterable
    include Inputable

    attr_reader :schema

    def initialize(schema)
      @schema = schema
    end

    def iter
      Enumerator.new do |rsp|
        input.each do |record|
          new_data = apply_schema(record)
          new_record = Record.new(new_data, record.params)
          rsp << new_record
        end
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
