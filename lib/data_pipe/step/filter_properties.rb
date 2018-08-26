
module DataPipe::Step
  class FilterProperties
    include DataPipe::Stepable

    def step_command
      :filter_properties
    end

    def process(record)
      filtered = record.data.select{|k,v| params.keys.include? k}
      Record.new(filtered, record.params)
    end
  end
end
