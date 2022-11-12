# frozen_string_literal: true

require 'async'
require 'async/worker'
require_relative './logging'
require_relative './fetcher'
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
      case sitemaps.size
      when 0
        logger.info 'No sitemaps'
      when 1
        handle_job(sitemaps.first)
      else
        run_reactor(sitemaps)
      end
      :ok
    end

    private

    def run_reactor(sitemaps)
      Async::Reactor.run do |task|
        # Make a pool with N workers:
        pool = Async::Worker::Pool.new(pool_size(sitemaps.size))

        tasks = sitemaps.collect do |sitemap_url|
          task.async do
            # Add the work to the queue and wait for it to complete:
            pool.async do
              handle_job(sitemap_url)
            end
          end
        end
        tasks.each(&:wait)

        pool.close
      end
    end

    def pool_size(jobs_size)
      return 1 if jobs_size <= 1

      case jobs_size
      when 2..4
        2
      when 5..8
        3
      else
        4 # max
      end
    end

    def sitemaps
      resp = @fetcher.fetch_path(ROBOTS_TXT)
      raise "Unable to fetch #{ROBOTS_TXT}" unless resp.success?

      robots_parser = SimpleSiteCrawler::Parsers::Robots.new(resp.body)
      robots_parser.sitemaps
    end

    def handle_job(sitemap_url)
      logger.info sitemap_url
    end
  end
end
