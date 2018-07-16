require "data_pipe/step/schema/field_schema"
require "data_pipe/error"
require "date"

module DataPipe::Step::Schema
  class DateFieldSchema < FieldSchema
    def apply(value, record=nil)
      Date.strptime(value, params.format)
    rescue Exception => err
      raise ValidationError.new(record, err)
    end
  end
end