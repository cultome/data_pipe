require "ostruct"
require "data_pipe/loggable"

module DataPipe::Stepable
  include Enumerable
  include DataPipe::Loggable

  attr_reader :input
  attr_reader :params
  attr_reader :fnc

  def prepare(params={}, &blk)
    @params = OpenStruct.new(default_params.merge(params))
    @fnc = blk
    self
  end

  def default_params
    {}
  end

  def set_input(input)
    @input = input
    self
  end

  def each
    return iter unless block_given?
    iter.each{|record| yield record }
  end

  def process(record)
    raise "must implement it first!"
  end

  def iter
    Enumerator.new do |rsp|
      input.each do |record|
        value = process(record)
        log "#{input.class} -> #{value} -> #{self.class}"
        rsp << value unless value.nil?
      end
    end
  end
end
