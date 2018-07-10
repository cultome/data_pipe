
module DataPipe
  module Iterable
    include Enumerable

    def each
      return iter unless block_given?
      iter.each{|record| yield record }
    end
  end
end
