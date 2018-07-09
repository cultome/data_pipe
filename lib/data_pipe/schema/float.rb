require "data_pipe/schema/field_schema"
require "data_pipe/error"

module DataPipe
  class FloatFieldSchema < FieldSchema
    def apply(value, record=nil)
      fl_val = value.to_f

      unless params.min.nil?
        raise ValidationError.new(record) unless fl_val >= params.min
      end

      unless params.max.nil?
        raise ValidationError.new(record) unless fl_val <= params.max
      end

      fl_val
    rescue
      raise ValidationError.new(record)
    end
  end
end
