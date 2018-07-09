require "data_pipe/schema/field_schema"

module DataPipe
  class IntFieldSchema < FieldSchema
    def apply(value)
      int_val = value.to_i

      unless params.min.nil?
        raise "validation error" unless int_val >= params.min
      end

      unless params.max.nil?
        raise "validation error" unless int_val <= params.max
      end

      int_val
    rescue
      raise "validation error"
    end
  end
end
