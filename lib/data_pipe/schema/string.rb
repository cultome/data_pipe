require "data_pipe/schema/field_schema"

module DataPipe
  class StringFieldSchema < FieldSchema
    def apply(value, record)

      unless params.format.nil?
        raise ValidationError.new(record) unless value.to_s.match? params.format
      end

      value.to_s
    end
  end
end
