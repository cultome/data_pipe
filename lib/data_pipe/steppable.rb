require "data_pipe/loggable"

module DataPipe::Steppable
  include Enumerable
  include DataPipe::Loggable

  attr_reader :input

  def set_input(input)
    @input = input
    self
  end

  def each
    return iter unless block_given?
    iter.each{|record| yield record }
  end

  def process(record)
    raise "must implement first"
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
