require 'test/unit'
require_relative 'Locker.rb'
require_relative 'LockerAssigner.rb'
require_relative 'SettingsReader.rb'
require_relative 'Interpreter.rb'

class Test_Settings_Reader < Test::Unit::TestCase
  def setup
    SettingsReader.new(File.expand_path("../test_settings.yaml", __FILE__))
  end
  
  def test_settings_read
    assert(SettingsReader.get_setting("test") == true)
  end
end

class Test_Locker < Test::Unit::TestCase
  def setup
    SettingsReader.new(File.expand_path("../test_settings.yaml", __FILE__))
  end
  
  def test_begins_available
    locker = Locker.new("SmallLockers", 0)
    assert(locker.available)
    assert(locker.customer == nil)
    assert(locker.number == 0)
  end
  
  def test_can_assign
    locker = Locker.new("SmallLockers", 0)
    locker.assign("Bruce Wayne")
    assert(!locker.available)
    assert(locker.customer == "Bruce Wayne")
    assert(locker.number == 0)
  end
  
  def test_all_locker_types
    small_locker = Locker.new("SmallLockers", 0)
    medium_locker = Locker.new("MediumLockers", 0)
    large_locker = Locker.new("LargeLockers", 0)
    assert(small_locker.type == "SmallLockers")
    assert(medium_locker.type == "MediumLockers")
    assert(large_locker.type == "LargeLockers")
  end
end

class Test_Locker_Assigner < Test::Unit::TestCase

  def setup
    SettingsReader.new(File.expand_path("../test_settings.yaml", __FILE__))

    for i in 0..5
      LockerAssigner.unassign("SmallLockers", i)
      LockerAssigner.unassign("MediumLockers", i)
      LockerAssigner.unassign("LargeLockers", i)
    end
  end
  
  def test_assign_one_locker
    smallLocker = LockerAssigner.assign(5, 5, 5, "Bruce Wayne")
    assert(smallLocker.type == "SmallLockers", smallLocker.type)
    assert(!smallLocker.available)
    assert(smallLocker.customer == "Bruce Wayne")
  end
  
  def test_assign_many_lockers
    
    for i in 0..5
      LockerAssigner.assign(10, 10, 10, i.to_s)
    end
    large_locker = LockerAssigner.assign(10, 10, 10, "I should be a large locker")
    assert(large_locker != nil)
    assert(large_locker.type == "LargeLockers", large_locker.type)
    assert(large_locker.customer == "I should be a large locker")
  end
  
  def test_assign_large_lockers
    large_locker = LockerAssigner.assign(20, 20, 20, "Clark Kent")
    assert(large_locker.type == "LargeLockers")
  end
end

class Test_interpreter < Test::Unit::TestCase
  def setup
    SettingsReader.new(File.expand_path("../test_settings.yaml", __FILE__))
  
    for i in 0..5
      LockerAssigner.unassign("SmallLockers", i)
      LockerAssigner.unassign("MediumLockers", i)
      LockerAssigner.unassign("LargeLockers", i)
    end
  end
  
  def test_assign_valid_command
    expected = "Locker Assigned\n"
    expected += "Locker type: MediumLockers\n"
    expected += "Locker Number: 0\n"
    expected += "Customer: Bruce Wayne\n"
    
    interpreter = Interpreter.new
    msg = interpreter.execute_command("checkin 1 6 3 Bruce Wayne")
    assert(msg == expected, msg)
  end
  
  def test_assign_invalid_command
    interpreter = Interpreter.new
    msg = interpreter.execute_command("checkin thisIsNotANumber 2 3 Bruce Wayne")
    assert(msg == "Measurements are not valid.")
  end
  
  def test_checkout_valid_command
    smallLocker = LockerAssigner.assign(5, 5, 5, "Bruce Wayne")
    interpreter = Interpreter.new
    msg = interpreter.execute_command("checkout SmallLockers " + smallLocker.number.to_s)
    assert(msg == "Locker successfully unassigned.", msg)
  end
  
  def test_checkout_invalid_command
    interpreter = Interpreter.new
    msg = interpreter.execute_command("checkout somethingsomething 10")
    assert(msg == "Locker was not assigned to anyone or locker type does not exist.", msg)
  end
  
  def test_invalid_command
    interpreter = Interpreter.new
    msg = interpreter.execute_command("this is a garbage command")
    assert(msg == "Command not understood.", msg)
  end
end