require_relative 'incident'
require_relative 'team'

class IncidentTriage
  attr_reader :incidents, :teams
  
  def initialize
    @incidents = {}
    @teams = {}
    @next_incident_id = 1
  end
  
  def register_team(team)
    raise ArgumentError, "Team cannot be nil" if team.nil?
    @teams[team.name] = team
  end
  
  def create_incident(severity, affected_service)
    raise ArgumentError, "Affected service cannot be empty" if affected_service.nil? || affected_service.strip.empty?
    
    incident_id = @next_incident_id
    @next_incident_id += 1
    
    incident = Incident.new(incident_id, severity, affected_service)
    @incidents[incident_id] = incident
    
    incident
  end
  
  def find_team_for_service(service)
    return nil if service.nil? || service.strip.empty?
    @teams.values.find { |team| team.owns_service?(service) }
  end
  
  def auto_assign_incident(incident)
    raise ArgumentError, "Incident cannot be nil" if incident.nil?
    
    team = find_team_for_service(incident.affected_service)
    raise StandardError, "No team found for service: #{incident.affected_service}" if team.nil?
    
    team.name
  end
  
  def resolve_incident(incident)
    raise ArgumentError, "Incident cannot be nil" if incident.nil?
    
    incident.resolve
  end
end
