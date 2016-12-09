require_relative 'Locker.rb'
require_relative 'SettingsReader.rb'
class LockerAssigner
  
  @@lockers_assigned = { "SmallLockers" => {}, "MediumLockers" => {}, "LargeLockers" => {} }

  def self.assign(length, width, height, customer_name)
      small_settings = SettingsReader.get_setting("SmallLockers")
      medium_settings = SettingsReader.get_setting("MediumLockers")
      large_settings = SettingsReader.get_setting("LargeLockers")
      if self.will_fit_in_locker(small_settings, length, width, height) and @@lockers_assigned["SmallLockers"].length < small_settings["totalAmount"]
        locker_type = "SmallLockers"
        max_lockers = small_settings["totalAmount"]
      elsif self.will_fit_in_locker(medium_settings, length, width, height) and @@lockers_assigned["MediumLockers"].length < medium_settings["totalAmount"]
        locker_type = "MediumLockers"
        max_lockers = medium_settings["totalAmount"]
      elsif @@lockers_assigned["LargeLockers"].length < large_settings["totalAmount"]
        locker_type = "LargeLockers"
        max_lockers = large_settings["totalAmount"]
      else
        return nil
      end
      for i in 0..max_lockers
        if not @@lockers_assigned[locker_type].has_key? i
          locker = Locker.new(locker_type, i)
          locker.assign(customer_name)
          @@lockers_assigned[locker_type][i] = locker
          return locker
        end
      end
      locker = Locker.new(locker_type, next_number)
      locker.assign(customer_name)

      return locker
  end

  def self.unassign(locker_type, number)
    if !@@lockers_assigned.has_key? locker_type
      return false
    end
    if !@@lockers_assigned[locker_type].has_key? number
      return false
    end
    @@lockers_assigned[locker_type].delete(number)
    return true
  end
  
  def self.will_fit_in_locker(locker_settings, x, y, z)
    max_width = locker_settings["width"]
    max_length = locker_settings["length"]
    max_height = locker_settings["height"]
    # definitely won't fit
    if [x, y, z].max > [max_length, max_height, max_width].max
      return false
    end
    
    # Determine if we can rotate the box in some way so it will fit
    # There are only 6 possible cases, so enumerating them all isn't a big deal
    if x <= max_width and y <= max_length and z <= max_height
      return true
    end
    if x <= max_width and y <= max_height and z <= max_length
      return true
    end
    if x <= max_length and y <= max_width and z <= max_height
      return true
    end
    if x <= max_length and y <= max_height and z <= max_width
      return true
    end
    if x <= max_height and y <= max_width and z <= max_length
      return true
    end
    if x <= max_height and y <= max_length and z <= max_width
      return true
    end
    return false
  end
  
  def self.get
    puts @@lockers_assigned
  end
end

