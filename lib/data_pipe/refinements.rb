
module DataPipe::StringUtils
  refine String do
    def strip
      self.gsub("\u00A0", " ").lstrip.rstrip
    end
  end
end
