require_relative 'lib/incident_triage'

puts "\n=== Hulu Incident Management Demo ==="

triage = IncidentTriage.new

web_team = Team.new("Web Platform", "Jada", ["frontend", "ui", "redirect"])
mobile_team = Team.new("Mobile Apps", "Charlie", ["mobile", "ios", "android"])

triage.register_team(web_team)
triage.register_team(mobile_team)

incident = triage.create_incident(1, "redirect")

puts "CRITICAL: Incident ##{incident.id} - All users redirected to Disney+ price notification"
puts "   Severity: #{incident.severity} | Service: #{incident.affected_service}"
puts "   Reported at: 2024-09-29 15:32:45"

assigned_team = triage.auto_assign_incident(incident)

puts "Assigned to #{assigned_team} team (on-call: #{web_team.on_call_engineer})"

incident.add_update("Users cannot access any content - all pages redirect to Disney+ pricing page")
puts "\nUPDATE: #{incident.updates.last[:message]} (15:32:45)"

incident.add_update("Confirmed affecting both web browser and mobile apps")
puts "UPDATE: #{incident.updates.last[:message]} (15:39:18)"

incident.add_update("Found misconfigured redirect rule in content delivery system")
puts "UPDATE: #{incident.updates.last[:message]} (16:02:52)"

triage.resolve_incident(incident)

puts "\nIncident resolved - redirect rule fixed, users can access content again"
puts "   Final status: #{incident.status}"
puts "   Resolved at: 2024-09-29 16:27:34"
puts "   Sales impact? YES"
