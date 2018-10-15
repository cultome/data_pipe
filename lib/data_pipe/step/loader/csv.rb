require "data_pipe/error"
require "csv"

module DataPipe::Step::Loader
  class Csv
    attr_reader :file

    def step_name
      :load_from_csv
    end

    def on_init(args={})
      path = args.fetch(:path)
      @file = CSV.open(path, "r", headers: true)
      self
    end

    def on_close
      file.close
      self
    end

    def next
      line = file.gets
      raise DataPipe::NoMoreElements.new if line.nil?
      # line.to_h
    end
  end
end
