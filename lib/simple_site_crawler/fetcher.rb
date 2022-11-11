module SimpleSiteCrawler
  class Fetcher
    USER_AGENTS = [
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:105.0) Gecko/20100101 Firefox/105.0',
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36',
      'Mozilla/5.0 (Linux; Android 13; SM-A205U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.5249.118 Mobile Safari/537.36',
    ].freeze

    def initialize(base_url)
      @conn = Faraday.new(url: base_url) do |f|
        f.adapter :typhoeus
      end
      @user_agent = USER_AGENTS.sample
    end

    def fetch_path(path)
      @conn.get(path, nil, { 'User-Agent' => @user_agent })
    end
  end
end
