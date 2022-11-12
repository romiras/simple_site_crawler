# frozen_string_literal: true

require 'sitemap-parser'

module SimpleSiteCrawler
  class SitemapIterator
    def initialize(sitemap_url)
      @sitemap = SitemapParser.new(sitemap_url, { recurse: true })
    end

    def call(&block)
      @sitemap.to_a.each(&block)
    end
  end
end
