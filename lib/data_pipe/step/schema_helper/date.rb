require "date"
require "data_pipe/step/schema_helper/field_schema"
require "data_pipe/error"

module DataPipe::Step::SchemaHelper
  class Date < FieldSchema
    def helper_command
      :date_field
    end

    def date_field(params=EMPTY_PARAMS, &blk)
      self
    end

    def apply(value, record=nil)
      ::Date.strptime(value, params.format)
    rescue Exception => err
      raise ValidationError.new(record, err)
    end
  end
end
