require "data_pipe/schema/field_schema"

module DataPipe::Schema
  class StringFieldSchema < FieldSchema
    def apply(value, record)

      unless params.format.nil?
        error_msg = "[#{value}] doesnt match the expected format [#{params.format}]"
        raise ValidationError.new(record, error_msg) unless value.to_s.match? params.format
      end

      value.to_s
    end
  end
end
