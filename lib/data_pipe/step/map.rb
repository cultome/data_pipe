
module DataPipe::Step
  class RecordMap
    include DataPipe::Steppable

    attr_reader :params
    attr_reader :fnc

    EMPTY_PARAMS = OpenStruct.new({})

    def initialize(params=EMPTY_PARAMS, &blk)
      @params = params
      @fnc = blk
    end

    def process(record)
      filtered = record.data.select{|k,v| params.include? k}
      Record.new(filtered, record.params)
    end
  end
end
