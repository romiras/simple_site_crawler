# frozen_string_literal: true

require 'set'
require 'faraday'
require 'faraday/typhoeus'
require_relative './logging'
require_relative './fetcher'
require_relative './async_worker_pool'
require_relative './parsers/robots'
module SimpleSiteCrawler
  # Core class of crawler
  class Core
    include Logging

    ROBOTS_TXT = '/robots.txt'

    def initialize(base_url)
      @fetcher = SimpleSiteCrawler::Fetcher.new(base_url)
    end

    def call
      executor = proc { |job| handle_job(job) }
      pool = SimpleSiteCrawler::AsyncWorkerPool.new(executor)

      sitemaps.each do |sitemap_url|
        pool.add_job(sitemap_url)
      end
      pool.close

      pool.run
    end

    private

    def sitemaps
      resp = @fetcher.fetch_path(ROBOTS_TXT)
      raise "Unable to fetch #{ROBOTS_TXT}" unless resp.success?

      robots_parser = SimpleSiteCrawler::Parsers::Robots.new(resp.body)
      robots_parser.sitemaps
    end

    def handle_job(job)
      p job
    end
  end
end
