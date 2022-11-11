require_relative './logging'

module SimpleSiteCrawler
  class AsyncWorkerPool
    include Logging

    NUM_THREADS = 2

    def initialize(executor, num_workers = NUM_THREADS)
      @jobs = Queue.new
      @workers = []

      @num_workers = num_workers
      @num_workers.times do |i|
        @workers << new_worker(i)
      end
      @executor = executor
    end

    def run
      logger.debug("==> join workers")
      @workers.each(&:join)
      logger.debug("Left #{@jobs.length} jobs")
    end

    def add_job(job)
      logger.debug("==> pushing a job")
      @jobs << job
      logger.debug("==> job pushed")
      logger.debug("Now #{@jobs.length} jobs are pending")
    end

    def close
      add_job(nil)
      @jobs.close
    end

    private

    def new_worker(wid)
      Thread.new do
        while jobs?(wid) && (job = @jobs.pop(true))
          logger.debug("worker #{wid}: job start")
          @executor.call(job) unless job.nil?
          logger.debug("worker #{wid}: job done")
        end
      end
    end

    def jobs?(wid)
      x = !@jobs.closed? && !@jobs.empty?
      logger.debug("worker #{wid}: no more jobs. Done")
      x
    end
  end
end
