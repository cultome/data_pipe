require "data_pipe/schema/field_schema"

module DataPipe
  class IntFieldSchema < FieldSchema
    def apply(value)
      int_val = value.to_i
      raise "validation error" unless int_val >= params.min && int_val <= params.max
      int_val
    rescue
      raise "validation error"
    end
  end
end
