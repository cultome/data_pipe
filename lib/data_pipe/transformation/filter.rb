
module DataPipe
  class FilterTransformation < Transformation
    def process!
      input.process! do |record|
        # require "pry";binding.pry
        filtered = record.data.select{|k,v| params.include? k}
        yield Record.new(filtered, record.params)
      end
    end
  end
end
