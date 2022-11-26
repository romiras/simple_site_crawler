# frozen_string_literal: true

require 'uri'
require_relative './async_worker_pool'
require_relative './logging'
require_relative './fetcher'
require_relative './parsers/robots'
require_relative './sitemap_iterator'
module SimpleSiteCrawler
  # Core class of crawler
  class Core
    include Logging

    ROBOTS_TXT = '/robots.txt'

    def initialize(base_url, options: {})
      @fetcher = SimpleSiteCrawler::Fetcher.new(base_url)
      @regex_patterns = options.fetch(:regex_patterns, [])
    end

    def call
      case sitemaps.size
      when 0
        logger.info 'No sitemaps'
      when 1
        crawl_sitemap(sitemaps.first)
      else
        SimpleSiteCrawler::AsyncWorkerPool.new(sitemaps).call do |sitemap_url|
          crawl_sitemap(sitemap_url)
        end
      end
      :ok
    end

    private

    def sitemaps
      resp = @fetcher.fetch_path(ROBOTS_TXT)
      raise "Unable to fetch #{ROBOTS_TXT}" unless resp.success?

      robots_parser = SimpleSiteCrawler::Parsers::Robots.new(resp.body)
      robots_parser.sitemaps
    end

    def crawl_sitemap(sitemap_url)
      logger.info "Processing #{sitemap_url}"
      URI.parse(sitemap_url)

      SimpleSiteCrawler::SitemapIterator.new(sitemap_url).call do |urls|
        crawl_resources(urls)
      end
    end

    def crawl_resources(urls)
      p urls
      SimpleSiteCrawler::AsyncWorkerPool.new(urls).call do |url|
        crawl_resource(URI.parse(url)) unless skip_resource?(url)
      end
    end

    def skip_resource?(url)
      return false if @regex_patterns.empty?

      skip = true
      @regex_patterns.each do |regex_pattern|
        skip = false unless regex_pattern.match?(url)
      end
      skip
    end

    def crawl_resource(uri)
      path = uri.path
      logger.info "Processing #{path}"

      resp = @fetcher.fetch_path(path)
      unless resp.success?
        logger.error "Error: #{resp.status}. Unable to fetch #{path} ."
        return
      end

      p(path, resp.body[0, 500])
    end
  end
end
