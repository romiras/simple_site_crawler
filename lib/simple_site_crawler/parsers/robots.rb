# frozen_string_literal: true

require 'set'

module SimpleSiteCrawler
  module Parsers
    # Parse robots.txt
    class Robots
      def initialize(io)
        @io = io
        @sitemaps = Set.new
        parse
      end

      def sitemaps
        @sitemaps.to_a
      end

      private

      def parse
        @io.each_line do |line|
          next if line.length.zero?

          case line
          when /^\s*Sitemap\s*:.+$/
            parts = line.split(': ')

            @sitemaps << (parts[1].strip + (parts[2].nil? ? '' : parts[2].strip))
          end
        end
      end
    end
  end
end
