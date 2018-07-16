
module DataPipe::Step
  class Map
    include DataPipe::Steppable

    def pipe_command
      :filter_properties
    end

    def process(record)
      filtered = record.data.select{|k,v| params.keys.include? k}
      Record.new(filtered, record.params)
    end
  end
end
