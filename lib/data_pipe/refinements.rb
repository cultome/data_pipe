
module DataPipe::StringUtils
  refine String do
    def strip_spaces
      self
        .gsub("\u00A0", " ")
        .gsub("\n", "")
        .gsub("\s+", " ")
        .lstrip.rstrip
    end

    def titlecase
      exceptions = %w{ el la los las un una unos una a ante bajo cabe con contra de desde en entre hacia hasta para por segun según sin so sobre tras durante mediante versus vía }

      words = self.split(" ")
        .map(&:downcase)
        .map do |word|
        if exceptions.include? word
          word
        else
          word[0].upcase + word[1..-1]
        end
      end

      phrase = words.join(" ")
      phrase[0].upcase + phrase[1..-1]
    end
  end
end
