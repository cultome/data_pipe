require "date"
require "data_pipe/step/schema_helper/field_schema"
require "data_pipe/error"

module DataPipe::Step::SchemaHelper
  class DateFieldSchema < FieldSchema
    def apply(value, record=nil)
      Date.strptime(value, params.format)
    rescue Exception => err
      raise ValidationError.new(record, err)
    end
  end
end
