require "data_pipe/step/schema_helper/field_schema"
require "data_pipe/error"

module DataPipe::Step::SchemaHelper
  class Int < FieldSchema
    def helper_command
      :int_field
    end

    def int_field(params=EMPTY_PARAMS, &blk)
      self
    end

    def apply(value, record=nil)
      int_val = Integer(value)

      unless params.min.nil?
        error_msg =  "[#{int_val}] has not the minimum expected value [#{params.min}]"
        raise ValidationError.new(record, error_msg) unless int_val >= params.min
      end

      unless params.max.nil?
        error_msg =  "[#{int_val}] exceeded the maximum expected value [#{params.max}]"
        raise ValidationError.new(record, error_msg) unless int_val <= params.max
      end

      int_val
    rescue Exception => err
      raise ValidationError.new(record, err)
    end
  end
end
