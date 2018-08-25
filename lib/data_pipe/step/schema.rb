require "data_pipe/record"
require 'data_pipe/step/schema_helper/date'
require 'data_pipe/step/schema_helper/string'
require 'data_pipe/step/schema_helper/int'
require 'data_pipe/step/schema_helper/float'
require "data_pipe/steppable"

module DataPipe::Step
  class Schema
    include DataPipe::Stepable

    def step_command
      :apply_schema
    end

    def process(record)
      new_data = check_schema(record)
      new_record = Record.new(new_data, record.params)
      new_record
    end

    private

    def check_schema(record)
      record.data.reduce({}) do |acc,(key,value)|
        acc[key] = transform_field(key, value, record)
        acc
      end
    end

    def transform_field(field, value, record)
      if params.definition.has_key? field
        params.definition[field].apply(value, field, record)
      else
        value
      end
    end
  end
end
