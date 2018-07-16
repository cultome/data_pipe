require "data_pipe/step/schema_helper/field_schema"

module DataPipe::Step::SchemaHelper
  class String < FieldSchema
    def helper_command
      :string_field
    end

    def string_field(params=EMPTY_PARAMS, &blk)
      self
    end

    def apply(value, record)
      if params.respond_to?(:format) && !params.format.nil?
        error_msg = "[#{value}] doesnt match the expected format [#{params.format}]"
        raise ValidationError.new(record, error_msg) unless value.to_s.match? params.format
      end

      value.to_s
    end
  end
end
