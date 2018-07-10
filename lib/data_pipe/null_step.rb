
module DataPipe
  class NullStep
    include Iterable
    include Inputable

    def iter
      Enumerator.new do |rsp|
        loop do
          rsp << nil
        end
      end
    end
  end
end
