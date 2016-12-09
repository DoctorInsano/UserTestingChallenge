require_relative 'Locker.rb'
class TicketGenerator
  def self.generate(locker)
    if locker == nil
	  return "No available lockers will fit the given luggage."
	end
    msg = "Locker Assigned\n"
    msg += "Locker type: " + locker.type + "\n"
    msg += "Locker Number: " + locker.number.to_s + "\n"
    msg += "Customer: " + locker.customer + "\n"
	return msg
  end
end
