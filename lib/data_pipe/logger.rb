require "logger"
require "forwardable"

module DataPipe
  module Loggable
    def log_to(output)
      @@logger ||= Logger.new(output)
    end

    def logger
      @@logger ||= Logger.new(STDOUT)
    end

    def log(msg)
      logger.info msg
    end
  end
end
