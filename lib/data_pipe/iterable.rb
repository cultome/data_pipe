
module DataPipe
  module Iterable
    def each
      return iter unless block_given?
      iter.each{|record| yield record }
    end
  end
end
