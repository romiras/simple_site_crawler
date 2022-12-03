# Web-crawler in Ruby

https://www.rubydoc.info/gems/rwget

watir

https://felipecsl.github.io/wombat/


## Parsers

* https://github.com/gjtorikian/robotstxt-parser
* https://rubygems.org/gems/sitemap-parser
* https://github.com/rubycocos/feedparser
* https://github.com/nicholasbergesen/RobotsParser - C#

## Sitemap examples

* https://www.rubylove.com/sitemap.xml
* https://qna.habr.com/sm-index.xml
    * https://hsto.org/getpro/toster/sitemap/20221126/index.xml

## Crawling algorithm

1. Validate URL
1. await GET `/robots.txt`.
1. Parse robots.txt: for each `Sitemap` push to `SitemapsQueue`.
1. For each sitemap URL in `SitemapsQueue` await GET.
1. Parse sitemap XML:
	1. for each `Sitemap` push to `SitemapsQueue`.
	1. for each URL validate with regexp, then push to `UrlsQueue`.
1. For each page URL in `UrlsQueue`:
	1. await cached meta-data from Memcached/Redis.
	1. return if found and not expired.
	1. await GET.
1. Parse HTML document. Extract OG tags with ogp.
1. store meta-data to Memcached/Redis.

### Handling HTTP errors

If has error and recoverable, retry after some time.

## Quotes

https://www.webscrapingapi.com/ruby-web-scraping/

In HTTP headers, a variety of additional information can be found about requests and responses. For web scraping, these are the ones that matter:

* User-Agent: web scrapers rely on this header to make their requests seem more realistic; it contains information such as the application, operating system, software, and version.
* Cookie: the server and request can exchange confidential information (such as authentication tokens).
* Referrer: contains the source site the user visited; accordingly, it is essential to consider this fact.
* Host: it identifies the host that you are connecting to.
* Accept: provides a response type for the server (e.g., text/plain, application/json).
