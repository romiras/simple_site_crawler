require_relative './logging'

module SimpleSiteCrawler
  class AsyncWorkerPool
    include Logging

    NUM_THREADS = 2

    def initialize(executor, num_workers = NUM_THREADS)
      @sitemaps_q = Queue.new
      @workers = []

      @num_workers = num_workers
      @num_workers.times do |i|
        @workers << new_worker(i)
      end
      @executor = executor
      @q_emptiness_check_disabled = false
    end

    def run
      @workers.each(&:join)
      @num_workers.times { |i| logger.debug("worker #{i}: done") }

      logger.debug("Left #{@sitemaps_q.length} jobs")
    end

    def add_job(job)
      logger.debug("==> pushing a job")
      @sitemaps_q << job
      logger.debug("==> job pushed")
      logger.debug("Now #{@sitemaps_q.length} jobs are pending")
    end

    private

    def new_worker(wid)
      Thread.new do
        logger.debug "worker #{wid}: started as asleep"
        while !@sitemaps_q.closed? && (@q_emptiness_check_disabled || !@sitemaps_q.empty?) && (job = @sitemaps_q.pop(true))
          logger.debug("worker #{wid}: job start")
          @executor.call(job) unless job.nil?
          logger.debug("worker #{wid}: job done")
        end
        logger.debug("worker #{wid}: no more jobs")
      end
    end

    def close
      add_job(nil)
      @sitemaps_q.close
    end
  end
end
