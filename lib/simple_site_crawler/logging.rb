require 'logger'

module SimpleSiteCrawler
  module Logging # Credits: https://stackoverflow.com/a/6768164/10118318
    # This is the magical bit that gets mixed into your classes
    def logger
      Logging.logger
    end

    # Global, memoized, lazy initialized instance of a logger
    def self.logger
      @logger ||= Logger.new($stdout)
    end
  end
end
