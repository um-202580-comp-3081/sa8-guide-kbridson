require "incident"

RSpec.describe Incident do
  let(:incident) { Incident.new(1, 4, "ui") }
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

  describe "#escalate" do
    it "reduces severity by 1 if > 1" do
      inc = Incident.new(1, 4, "ui")

      expect { inc.escalate }.to change { inc.severity }.by(-1)
    end
    it "errors if severity = 1" do
      inc = Incident.new(1, 1, "ui")

      expect { inc.escalate }.to raise_error(StandardError)
    end
  end

  describe "#resolve" do
    it "sets status resolved and sets resolved_at" do
      inc = Incident.new(1, 4, "ui")
      allow(Time).to receive(:now).and_return(Time.new(2025,9,28))

      inc.resolve

      expect(inc.status).to eq "resolved"
      expect(inc.resolved_at).to eq Time.new(2025,9,28)
    end

    it "raises error if incident already resolved" do
      inc = Incident.new(1, 4, "ui")

      expect { inc.escalate }.to change { inc.severity }.by(-1)
    end
  end

  describe "#add_update" do
    it "appends update with message and timestamp if message" do
      inc = Incident.new(1, 4, "ui")
      message = "New message"
      timestamp = Time.new(2025,9,28)
      allow(Time).to receive(:now).and_return(Time.new(2025,9,28))

      inc.add_update(message)

      expect(inc.updates.last[:message]).to eq message
      expect(inc.updates.last[:timestamp]).to eq timestamp
    end
    it "catches empty message" do
      inc = Incident.new(1, 4, "ui")
      message = ""
      timestamp = Time.new(2025,9,28)
      allow(Time).to receive(:now).and_return(Time.new(2025,9,28))

      expect { inc.add_update(message) }.to raise_error(ArgumentError)
    end
  end

  describe "#critical?" do
    it "returns true if severity = 1" do
      inc = Incident.new(1, 1, "ui")

      expect(inc.critical?).to be true
    end
    it "returns false if severity != 1" do
      inc = Incident.new(1, 4, "ui")

      expect(inc.critical?).to be false
    end
  end

  describe "#resolved?" do
    it "returns true if status = resolved" do
      inc = Incident.new(1, 1, "ui")
      inc.resolve

      expect(inc.resolved?).to be true
    end
    it "returns false if status != resolved" do
      inc = Incident.new(1, 4, "ui")

      expect(inc.resolved?).to be false
    end
  end

  describe "#open?" do
    it "returns true if status == 'open'" do
      inc = Incident.new(1, 1, "ui")

      expect(inc.open?).to be true
    end
    it "returns false if status != 'open'" do
      inc = Incident.new(1, 4, "ui")
      inc.resolve

      expect(inc.open?).to be false
    end
  end
end
