require "data_pipe/schema/field_schema"
require "date"

module DataPipe
  class DateFieldSchema < FieldSchema
    def apply(value)
      Date.strptime(value, params.format)
    rescue
      raise "validation error"
    end
  end
end
