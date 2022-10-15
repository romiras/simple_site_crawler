# frozen_string_literal: true

require 'set'
require 'faraday'
require 'faraday/typhoeus'
require_relative './parsers/robots'
module SimpleSiteCrawler
  # Core class of crawler
  class Core
    USER_AGENTS = [
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:105.0) Gecko/20100101 Firefox/105.0',
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36',
      'Mozilla/5.0 (Linux; Android 13; SM-A205U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.5249.118 Mobile Safari/537.36',
    ].freeze

    ROBOTS_TXT = '/robots.txt'

    def initialize(base_url)
      @base_url = base_url
      @conn = Faraday.new(url: @base_url) do |f|
        f.adapter :typhoeus
      end
      @user_agent = USER_AGENTS.sample
      @sitemaps_q = Queue.new
    end

    def call
      sitemaps.each do |sitemap|
        p sitemap
        @sitemaps_q << sitemap
      end
    end

    private

    def fetch_path(path)
      @conn.get(path, nil, { 'User-Agent' => @user_agent })
    end

    def sitemaps
      resp = fetch_path(ROBOTS_TXT)
      raise "Unable to fetch #{ROBOTS_TXT}" unless resp.success?

      robots_parser = SimpleSiteCrawler::Parsers::Robots.new(resp.body)
      robots_parser.sitemaps
    end
  end
end
