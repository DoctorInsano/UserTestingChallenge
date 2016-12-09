require_relative 'LockerAssigner.rb'
require_relative 'TicketGenerator.rb'
class Interpreter

  def initialize()
  end
  
  def execute_command(command)
    arguments = command.split
    if arguments[0] == "checkout"
      return unassign(arguments)
    elsif arguments[0] == "checkin"
      return assign(arguments)
    else
      return "Command not understood."
    end
  end

  def assign(args)
    if (args.length < 5)
      return nil
    end
	
	begin
		length = Float(args[1])
		width = Float(args[2])
		height = Float(args[3])
  rescue ArgumentError
    return "Measurements are not valid."
  end
	name = args[4..args.length].join(" ")
  return TicketGenerator.generate(LockerAssigner.assign(length, width, height, name))
	end
end

  def unassign(args)
    if (args.length != 3)
      return nil
    end
    begin
      id = Integer(args[2])
    rescue ArgumentError
      return "Invalid locker number."
    end
    if LockerAssigner.unassign(args[1], id)
      return "Locker successfully unassigned."
    end
    return "Locker was not assigned to anyone or locker type does not exist."
  end
