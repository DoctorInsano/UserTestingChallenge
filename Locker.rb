require_relative 'SettingsReader.rb'
class Locker

  attr_reader :type
  attr_reader :length
  attr_reader :width
  attr_reader :height
  attr_reader :available
  attr_reader :number
  attr_reader :customer
  
  def initialize(locker_type, number)
    settings = SettingsReader.get_setting(locker_type)
    @type = locker_type
    @length = settings["length"]
    @width = settings["width"]
    @height = settings["height"]
    @number = number
    @available = true
  end

  def assign(customer_name)
    @available = false
    @customer = customer_name
  end

end
