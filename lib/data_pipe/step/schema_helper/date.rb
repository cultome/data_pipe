require "date"
require "data_pipe/step/schema_helper/field_schema"
require "data_pipe/error"
require "data_pipe/refinements"

using DataPipe::StringUtils

module DataPipe::Step::SchemaHelper
  class Date < FieldSchema
    def helper_command
      :date_field
    end

    def date_field(params={}, &blk)
      self
    end

    def apply(value, field, record=nil)
      return unless params.format?
      return if !params.required? && value.to_s.empty?

      if value.is_a? ::Date
        ret_value = value.strftime(params.format)
      else
        ret_value = value.to_s.strip_spaces
      end

      return params.default if ret_value.empty? && params.default?

      regex = translate_to_regex(params.format)

      raise "[#{ret_value}] is not a valid date!" unless ret_value.match(regex)

      if params.past_only?
        date = ::Date.strptime(ret_value, params.format)
        raise "[#{date}] is a date in the future Doc!" if date > ::Date.today
      end

      ret_value
    rescue Exception => err
      raise DataPipe::Error::ValidationError.new(record.data, err.to_s + " in field [#{field}]")
    end

    private

    def translate_to_regex(format)
      regex = format
        .scan(/%\w/)
        .map{|exp|
          case exp
          when "%d" then ["%d", "[\\d]{2}"]
          when "%m" then ["%m", "[\\d]{2}"]
          when "%Y" then ["%Y", "[\\d]{4}"]
          end
        }
        .reduce(format){|acc, (exp, regex_piece)|
          acc.gsub(exp, regex_piece)
        }

      Regexp.new("^#{regex}$")
    end
  end
end
