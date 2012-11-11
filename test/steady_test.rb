require "test/unit"
require "steady"

class SteadyTask < Test::Unit::TestCase

  def setup
    @sched = Steady::Scheduler.new
  end  

  def test_tasks_run
    i = 0 
    @sched.every 1 do 
      i += 1
    end

    assert_equal 1, @sched.tasks.length 
    @sched.run
    assert_equal 1, @sched.tasks.length 

    assert_equal 1, i 
  end

  def test_task_sorting
    i = 0 

    @sched.every 2 do 
      i += 1
    end  
    @sched.every 5 do
      i += 1
    end
    @sched.every 1 do
      i += 1
    end

    @sched.run
    assert_equal 3, i

    sleep 1.1

    @sched.run
    assert_equal 4, i

    sleep 1.1

    @sched.run
    assert_equal 6, i    
  end

  def test_task_drowsiness

    @sched.every 5 do 
    end  

    assert_equal 1, @sched.drowsiness

    @sched.run 

    assert_equal 5, @sched.drowsiness    

    @sched.every 1 do 
    end  

    assert_equal 1, @sched.drowsiness
    
  end

  def test_mege

    assert_equal nil, @sched.data[:test]

    @sched.every 1 do |changes|
      changes[:test] = 'ok'
    end  

    @sched.run

    assert_equal 'ok', @sched.data[:test]    
  end

end