require "data_pipe/step/schema_helper/field_schema"
require "data_pipe/error"

module DataPipe::Step::SchemaHelper
  class String < FieldSchema
    def helper_command
      :string_field
    end

    def string_field(data=EMPTY_PARAMS, &blk)
      self
    end

    def apply(value, field, record)
      return params.default if value.to_s.empty? && params.default?

      if params.required?
        raise DataPipe::Error::ValidationError.new(record, "Field [#{field}] required!") if value.to_s.empty?
      end

      if params.format?
        error_msg = "[#{value}] doesnt match the expected format [#{params.format}] in field [#{field}]"
        raise DataPipe::Error::ValidationError.new(record, error_msg) unless value.to_s.match? params.format
      end

      value.to_s
    end
  end
end
