module SimpleSiteCrawler
  class UrlPathMatcher
    def initialize(regex_patterns)
      raise ArgumentError, 'invalid regex_patterns' unless valid?(regex_patterns)

      @regex_patterns = regex_patterns
    end

    def match?(path)
      return true if @regex_patterns.empty?

      @regex_patterns.any? { |regex_pattern| regex_pattern.match?(path) }
    end

    private

    def valid?(regex_patterns)
      regex_patterns.is_a?(Array) && regex_patterns.all? { |regex_pattern| regex_pattern.is_a?(Regexp) }
    end
  end
end
