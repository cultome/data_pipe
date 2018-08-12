require "data_pipe/step/schema_helper/field_schema"

module DataPipe::Step::SchemaHelper
  class String < FieldSchema
    def helper_command
      :string_field
    end

    def string_field(data=EMPTY_PARAMS, &blk)
      self
    end

    def apply(value, field, record)
      if params.format?
        error_msg = "[#{value}] doesnt match the expected format [#{params.format}] in field [#{field}]"
        raise ValidationError.new(record, error_msg) unless value.to_s.match? params.format
      end

      value.to_s
    end
  end
end
