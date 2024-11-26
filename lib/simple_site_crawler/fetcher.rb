# frozen_string_literal: true

require 'faraday'
require 'faraday/typhoeus'
require 'faraday/follow_redirects'

module SimpleSiteCrawler
  class Fetcher
    USER_AGENTS = [
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:107.0) Gecko/20100101 Firefox/107.0',
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36',
      'Mozilla/5.0 (Linux; Android 13; SM-A205U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.5249.118 Mobile ' \
        'Safari/537.36'
    ].freeze

    def initialize(base_url, options = {})
      @headers = {
        'Accept-Encoding' => 'gzip,deflate',
        'User-Agent' => USER_AGENTS.sample
      }.merge(options.fetch(:headers, {}))

      @conn = Faraday.new(url: base_url, headers: @headers) do |f|
        f.response :follow_redirects # use Faraday::FollowRedirects::Middleware
        f.adapter :typhoeus
      end
    end

    def fetch_path(path, headers = {})
      @conn.get(path, nil, @headers.merge(headers))
    end
  end
end
