
module DataPipe::Step
  class FilterProperties
    include DataPipe::Stepable

    def step_command
      :filter_properties
    end

    def process(record)
      filtered = record.data.select do |k,v|
        included = params.keys.include? k
        params.exclude ? !included : included
      end

      Record.new(filtered, record.params)
    end

    def default_params
      {
        exclude: false
      }
    end
  end
end
