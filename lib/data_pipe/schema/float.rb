require "data_pipe/schema/field_schema"

module DataPipe
  class FloatFieldSchema < FieldSchema
    def apply(value)
      fl_val = value.to_f
      raise "validation error" unless fl_val >= params.min && fl_val <= params.max
      fl_val
    rescue
      raise "validation error"
    end
  end
end
