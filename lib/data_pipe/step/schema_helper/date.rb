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

    def date_field(params=EMPTY_PARAMS, &blk)
      self
    end

    def apply(value, field, record=nil)
      return unless params.format?
      return if !params.required? && value.to_s.empty?

      return params.default if value.to_s.empty? && params.default?

      if value.is_a? ::String
        date = ::Date.strptime(value, params.format)
        ret_value = value.strip
      else
        date = value
        ret_value = value.strftime(params.format).strip
        record.data[field] = ret_value
      end

      regex = translate_to_regex(params.format)

      unless ret_value.match(regex)
        require "pry";binding.pry
        raise "[#{ret_value}] is not a valid date!"
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
