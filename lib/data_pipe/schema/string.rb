require "data_pipe/schema/field_schema"

module DataPipe
  class StringFieldSchema < FieldSchema
    def apply(value)
      raise "validation error" unless value.to_s.match? params.format
      value.to_s
    end
  end
end
