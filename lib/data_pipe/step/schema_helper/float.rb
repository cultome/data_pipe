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

    def apply(value, record=nil)
      fl_val = value.to_f

      unless params.min.nil?
        error_msg =  "[#{fl_val}] has not the minimum expected value [#{params.min}]"
        raise ValidationError.new(record, error_msg) unless fl_val >= params.min
      end

      unless params.max.nil?
        error_msg =  "[#{fl_val}] exceeded the expected value [#{params.max}]"
        raise ValidationError.new(record, error_msg) unless fl_val <= params.max
      end

      fl_val
    rescue Exception => err
      raise ValidationError.new(record, err)
    end
  end
end
