require "data_pipe/step/schema_helper/field_schema"
require "data_pipe/error"
require "data_pipe/refinements"

using DataPipe::StringUtils

module DataPipe::Step::SchemaHelper
  class Float < FieldSchema
    def helper_command
      :float_field
    end

    def float_field(params={}, &blk)
      self
    end

    def apply(value, field, record=nil)
      float_value = value.to_s.strip_spaces.gsub(/[^\d.]/, "")
      return if !params.required? && float_value.to_s.empty?

      return params.default if float_value.to_s.empty? && params.default?

      fl_val = Float(float_value)

      if params.min?
        error_msg =  "[#{fl_val}] has not the minimum expected value [#{params.min}] in field [#{field}]"
        raise DataPipe::Error::ValidationError.new(record, error_msg) unless fl_val >= params.min
      end

      if params.max?
        error_msg =  "[#{fl_val}] exceeded the expected value [#{params.max}] in field [#{field}]"
        raise DataPipe::Error::ValidationError.new(record, error_msg) unless fl_val <= params.max
      end

      fl_val
    rescue Exception => err
      error_msg =  "[#{fl_val}] in field [#{field}] throws [#{err}]"
      raise DataPipe::Error::ValidationError.new(record, error_msg)
    end
  end
end
