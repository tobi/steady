require 'speedytime'
require 'thread'
require 'set'

module Steady

  class SyncronizedHash
    def initialize
      @hash = Hash.new
      @mutex = Mutex.new
    end

    def [](key)
      @mutex.synchronize { @hash[key] }
    end

    def []=(key)
      @mutex.synchronize { @hash.[]=(key, value) }
    end

    def apply(changes)
      @mutex.synchronize { @hash.merge!(changes) }
    end
  end

  class DirtyTrackingHash < Hash
    def dirty?
      @dirty
    end

    def []=(key, value)
      @dirty = true
      super
    end
  end

  class Scheduler
    attr_reader :tasks, :data

    def initialize
      @tasks = []
      @data = SyncronizedHash.new
    end

    def every(interval, &block)
      push Task.new(interval, &block)
    end

    def run
      changes = DirtyTrackingHash.new
      runs = false 


      @tasks.each do |task|
        if task.needs_running?
          task.run(changes)
          runs = true 
        else
          # tasks are sorted, if a tasks doesn't need running 
          # then no task behind it will need running either at 
          # the moment.
          break
        end
      end

      # if tasks ran we resort the tasks and apply
      # any changes to the data hash 
      if runs
        @tasks.sort!
        @data.apply(changes) if changes.dirty?
        true
      else
        false
      end
    end

    def schedule
      Thread.new do 
        loop { sleep; run }
      end
    end

    def drowsiness
      drowsiness = (t = @tasks.first) ? t.next_run - Speedytime.current : 1
      drowsiness = 1 if drowsiness < 1
      drowsiness
    end

    def sleep      
      sleep(drowsiness)
    end

    private

    def push(task)    
      @tasks.push(task)
      @tasks.sort!
    end

  end

  class Task
    attr_accessor :last_run, :interval

    def initialize(interval, &block)
      @interval = interval
      @proc = block
      @last_run = 0
    end

    def next_run
      @last_run + @interval
    end

    def needs_running?
      next_run <= Speedytime.current
    end

    def run(changes = nil)
      if needs_running?
        @proc.call(changes)
        @last_run = Speedytime.current
        true
      else
        false
      end
    end

    def <=>(other)
      next_run <=> other.next_run
    end
  end

end
