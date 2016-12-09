#!/usr/bin/ruby
require_relative 'interpreter.rb'
require_relative 'SettingsReader.rb'

def main()
  interpreter = Interpreter.new
  puts "Locker Assigner Commands: "
  puts "checkin [length] [width] [height] [Customer Name]"
  puts "checkout [LockerType] [LockerNumber]"
  puts "Measurements are in " + SettingsReader.get_setting("Measurement_units")
  puts "Valid LockerTypes are SmallLockers, MediumLockers, and LargeLockers"
  while true
    puts interpreter.execute_command(gets.chomp)
  end
end

main()