require "data_pipe/step/schema_helper/field_schema"
require "data_pipe/error"

module DataPipe::Step::SchemaHelper
  class Float < FieldSchema
    def helper_command
      :float_field
    end

    def float_field(params=EMPTY_PARAMS, &blk)
      self
    end

    def apply(value, field, record=nil)
      float_value = value.to_s.gsub(" ", "").gsub(",", "")
      return if !params.required? && float_value.to_s.empty?

      fl_val = Float(float_value)

      if params.min?
        error_msg =  "[#{fl_val}] has not the minimum expected value [#{params.min}] in field [#{field}]"
        raise ValidationError.new(record, error_msg) unless fl_val >= params.min
      end

      if params.max?
        error_msg =  "[#{fl_val}] exceeded the expected value [#{params.max}] in field [#{field}]"
        raise ValidationError.new(record, error_msg) unless fl_val <= params.max
      end

      fl_val
    rescue Exception => err
      raise ValidationError.new(record, err)
    end
  end
end
