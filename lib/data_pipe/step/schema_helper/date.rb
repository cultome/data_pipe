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
      return unless params.format?
      return if !params.required? && value.to_s.empty?

      if value.is_a? ::String
        date = ::Date.strptime(value, params.format)
      else
        date = value
        record.data[field] = value.strftime(params.format)
      end

      if params.past_only?
        if date > ::Date.today
          raise DataPipe::Error::ValidationError.new(record.data, "[#{date}] is a date in the future Doc!")
        end
      end
    rescue Exception => err
      raise DataPipe::Error::ValidationError.new(record.data, err.to_s + " in field [#{field}]")
    end
  end
end
