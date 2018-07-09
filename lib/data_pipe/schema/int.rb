require "data_pipe/schema/field_schema"
require "data_pipe/error"

module DataPipe
  class IntFieldSchema < FieldSchema
    def apply(value, record=nil)
      int_val = Integer(value)

      unless params.min.nil?
        raise ValidationError.new(record) unless int_val >= params.min
      end

      unless params.max.nil?
        raise ValidationError.new(record) unless int_val <= params.max
      end

      int_val
    rescue
      raise ValidationError.new(record)
    end
  end
end
