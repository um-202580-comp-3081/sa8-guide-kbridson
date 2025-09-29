require "incident"

RSpec.describe Incident do
  describe ".initialize" do
    it "creates a valid Incident with severity and affected_service and sets attributes" do
      id = 1
      severity = 1
      affected_service = "ui"
      allow(Time).to receive(:now).and_return(Time.new(2025,9,28))

      inc = Incident.new(id, severity, affected_service)

      expect(inc).to be_a(Incident)
      expect(inc.id).to eq 1
      expect(inc.severity).to eq severity
      expect(inc.affected_service).to eq affected_service
      expect(inc.status).to eq 'open'
      expect(inc.reported_at).to eq Time.new(2025,9,28)
      expect(inc.resolved_at).to be nil
      expect(inc.updates).to be_empty
    end
    it "catches severity > 4" do
      id = 1
      severity = 5
      affected_service = "ui"

      expect { Incident.new(id, severity, affected_service) }.to raise_error(ArgumentError)
    end
    it "catches severity < 1" do
      id = 1
      severity = 0
      affected_service = "ui"

      expect { Incident.new(id, severity, affected_service) }.to raise_error(ArgumentError)
    end
  end
end
