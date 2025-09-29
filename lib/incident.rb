require 'time'

class Incident
  attr_reader :id, :severity, :affected_service, :status, :reported_at, :resolved_at, :updates
  
  def initialize(id, severity, affected_service)
    raise ArgumentError, "Severity must be between 1 and 4" unless severity.is_a?(Integer) && severity.between?(1, 4)
    
    @id = id
    @severity = severity
    @affected_service = affected_service
    @status = 'open'
    @reported_at = Time.now
    @resolved_at = nil
    @updates = []
  end
  
  def escalate
    raise StandardError, "Cannot escalate beyond severity 1" if critical?
    @severity -= 1
  end
  
  def resolve
    raise StandardError, "Cannot resolve incident that is not open" unless open?
    @status = 'resolved'
    @resolved_at = Time.now
  end
  
  def add_update(message)
    raise ArgumentError, "Update message cannot be empty" if message.nil? || message.strip.empty?
    @updates << { message: message, timestamp: Time.now }
  end
  
  def critical?
    @severity == 1
  end
  
  def resolved?
    @status == 'resolved'
  end
  
  def open?
    @status == 'open'
  end
end
