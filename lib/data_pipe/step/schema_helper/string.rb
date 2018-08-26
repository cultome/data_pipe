require "data_pipe/step/schema_helper/field_schema"
require "data_pipe/error"
require "data_pipe/refinements"

using DataPipe::StringUtils

module DataPipe::Step::SchemaHelper
  class String < FieldSchema
    def helper_command
      :string_field
    end

    def string_field(data=EMPTY_PARAMS, &blk)
      self
    end

    def apply(value, field, record)
      ret_value = value.to_s.strip_spaces
      return params.default if ret_value.empty? && params.default?

      if params.required?
        raise DataPipe::Error::ValidationError.new(record, "Field [#{field}] required!") if ret_value.empty?
      end

      if params.format?
        error_msg = "[#{ret_value}] doesnt match the expected format [#{params.format}] in field [#{field}]"
        raise DataPipe::Error::ValidationError.new(record, error_msg) unless ret_value.match? params.format
      end

      return ret_value.titlecase if params.titlecase?

      ret_value
    end
  end
end
