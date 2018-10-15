
module DataPipe::Refinements
  refine String do
    def pascalcase
      split("_").map{|w| w[0].upcase + w[1..-1]}.join
    end
  end
end
