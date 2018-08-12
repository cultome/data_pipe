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

    def apply(value, field, record=nil)
      return if !params.required? && value.to_s.empty?
      return unless params.format?

      if value.is_a? ::String
        ::Date.strptime(value, params.format)
      else
        record[field] = value.strftime(params.format)
      end
    rescue Exception => err
      raise ValidationError.new(record, err.to_s + " in field [#{field}]")
    end
  end
end
