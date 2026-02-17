# frozen_string_literal: true

require 'sitemap-parser'

module SimpleSiteCrawler
  class SitemapIterator
    def initialize(sitemap_url, slice_size: 10)
      @sitemap = SitemapParser.new(sitemap_url, { recurse: true })
      @slice_size = slice_size
    end

    def call(...)
      @sitemap.to_a.each_slice(@slice_size, ...)
    end
  end
end
