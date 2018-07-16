
module DataPipe::Step
  class Process
    include DataPipe::Steppable

    attr_reader :params
    attr_reader :fnc

    EMPTY_PARAMS = OpenStruct.new({})

    def initialize(params=EMPTY_PARAMS, &blk)
      @params = params
      @fnc = blk
    end

    def process(record)
      new_value = fnc.call(record.data)
      Record.new(new_value, record.params)
    end
  end
end
