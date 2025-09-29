class Team
  attr_reader :name, :on_call_engineer, :services
  
  def initialize(name, on_call_engineer, services)
    raise ArgumentError, "Team name cannot be empty" if name.nil? || name.strip.empty?
    raise ArgumentError, "On call engineer cannot be empty" if on_call_engineer.nil? || on_call_engineer.strip.empty?
    raise ArgumentError, "Services cannot be empty" if services.nil? || services.empty?
    
    @name = name
    @on_call_engineer = on_call_engineer
    @services = services
  end
  
  def owns_service?(service)
    @services.include?(service)
  end
  
  def primary_service
    @services.first
  end
end
