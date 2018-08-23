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

      return params.default if value.to_s.empty? && params.default?

      if value.is_a? ::String
        date = ::Date.strptime(value, params.format)
        ret_value = value
      else
        date = value
        ret_value = value.strftime(params.format)
        record.data[field] = ret_value
      end

      if params.past_only?
        if date > ::Date.today
          raise "[#{date}] is a date in the future Doc!"
        end
      end

      ret_value
    rescue Exception => err
      raise DataPipe::Error::ValidationError.new(record.data, err.to_s + " in field [#{field}]")
    end
  end
end
