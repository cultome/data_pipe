require "data_pipe/step/schema_helper/field_schema"
require "data_pipe/error"
require "data_pipe/refinements"

using DataPipe::StringUtils

module DataPipe::Step::SchemaHelper
  class Int < FieldSchema
    def helper_command
      :int_field
    end

    def int_field(params={}, &blk)
      self
    end

    def apply(value, field, record=nil)
      int_value = value.to_s.strip_spaces.gsub(",", "")
      return if !params.required? && int_value.empty?

      return params.default if int_value.empty? && params.default?

      int_val = Integer(int_value)

      if params.min?
        raise "[#{int_val}] has not the minimum expected value [#{params.min}] in field [#{field}]" unless int_val >= params.min
      end

      if params.max?
        raise "[#{int_val}] exceeded the maximum expected value [#{params.max}] in field [#{field}]" unless int_val <= params.max
      end

      int_val
    rescue Exception => err
      raise DataPipe::Error::ValidationError.new(record, err)
    end
  end
end
