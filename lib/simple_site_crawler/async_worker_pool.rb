# frozen_string_literal: true

require 'async'
require 'async/worker'

module SimpleSiteCrawler
  class AsyncWorkerPool
    def initialize(urls)
      @urls = urls
    end

    def call(&block)
      Async::Reactor.run do |task|
        # Make a pool with N workers:
        pool = Async::Worker::Pool.new(pool_size(@urls.size))

        tasks = @urls.collect do |url|
          task.async do
            # Add the work to the queue and wait for it to complete:
            pool.async do
              block.call(url)
            end
          end
        end
        tasks.each(&:wait)

        pool.close
      end
    end

    private

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
  end
end
