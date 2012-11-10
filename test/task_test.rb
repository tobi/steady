require "test/unit"
require "periodic"

class TestTask < Test::Unit::TestCase
	
  def test_tasks_run_by_default
    i = 0

  	task = Periodic::Task.new(5) do 
      i += 1
    end

    task.run 

    assert_equal 1, i
	end

  def test_tasks_run_one_per_second
    i = 0

    task = Periodic::Task.new(1) do 
      i += 1
    end

    task.run 
    task.run
    sleep 1.1
    task.run
    task.run

    assert_equal 2, i, 'should have been 2 because only 2 unique seconds elapsed'
  end

  def test_needs_running?
    task = Periodic::Task.new(1)
    assert task.needs_running? 
    task.last_run = Speedytime.current
    assert !task.needs_running?
    task.last_run = Speedytime.current - 5
    assert task.needs_running?
  end

  def test_interval
    task = Periodic::Task.new(1)
    task.last_run = Speedytime.current - 5
    assert task.needs_running?
    task.interval = 6 
    assert !task.needs_running?
  end
end