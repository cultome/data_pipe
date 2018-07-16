
module DataPipe::Step
  class Filter
    include DataPipe::Steppable

    attr_reader :params
    attr_reader :fnc

    EMPTY_PARAMS = OpenStruct.new({})

    def initialize(params=EMPTY_PARAMS, &blk)
      @params = params
      @fnc = blk
    end

    def process(record)
      fnc.call(record.data) ? record : nil
    end
  end
end
