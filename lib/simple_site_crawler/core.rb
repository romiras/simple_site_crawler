# frozen_string_literal: true

require 'robotstxt'
module SimpleSiteCrawler
  # Core class of crawler
  class Core
    USER_AGENTS = [
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:105.0) Gecko/20100101 Firefox/105.0',
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36',
      'Mozilla/5.0 (Linux; Android 13; SM-A205U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.5249.118 Mobile Safari/537.36',
    ].freeze

    def initialize(base_url)
      @base_url = base_url
    end

    def call
      user_agent = USER_AGENTS.sample

      # conn = Faraday.new(url: @base_url) do |f|
      #   f.adapter :typhoeus
      # end
      # resp = conn.get('/robots.txt')

      uri = URI.parse(@base_url)
      Net::HTTP.start(uri.host, uri.port) do |http|
        
        binding.pry
        
        robots = Robotstxt.get(http, user_agent)
        robots.sitemaps

        # if robots.allowed? "/index.html"
        #   http.get("/index.html")
        # elsif robots.allowed? "/index.php"
        #   http.get("/index.php")
        # end
      end
    end
  end
end
