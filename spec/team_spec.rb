require "team"

RSpec.describe Team do
  let(:web_team) { Team.new("Web Platform", "Jada", ["frontend", "ui", "redirect"]) }
  describe ".initialize" do
    it "creates a valid Team with name, on_call_engineer, and services and sets attributes" do
      name = "Web Platform"
      on_call_engineer = "Jada"
      services = ["frontend", "ui", "redirect"]

      team = Team.new(name, on_call_engineer, services)

      expect(team).to be_a(Team)
      expect(team.name).to eq name
      expect(team.on_call_engineer).to eq on_call_engineer
      expect(team.services).to match_array services
    end
    it "catches empty name" do
      name = ""
      on_call_engineer = "Jada"
      services = ["frontend", "ui", "redirect"]

      expect { Team.new(name, on_call_engineer, services) }.to raise_error(ArgumentError)
    end
    it "catches nil name" do
      name = nil
      on_call_engineer = "Jada"
      services = ["frontend", "ui", "redirect"]

      expect { Team.new(name, on_call_engineer, services) }.to raise_error(ArgumentError)
    end
    it "catches empty on-call engineer" do
      name = "Web Platform"
      on_call_engineer = ""
      services = ["frontend", "ui", "redirect"]

      expect { Team.new(name, on_call_engineer, services) }.to raise_error(ArgumentError)
    end
    it "catches nil on-call engineer" do
      name = "Web Platform"
      on_call_engineer = nil
      services = ["frontend", "ui", "redirect"]

      expect { Team.new(name, on_call_engineer, services) }.to raise_error(ArgumentError)
    end
    it "catches missing services" do
      name = "Web Platform"
      on_call_engineer = "Jada"
      services = nil

      expect { Team.new(name, on_call_engineer, services) }.to raise_error(ArgumentError)
    end
    it "catches empty services" do
      name = "Web Platform"
      on_call_engineer = "Jada"
      services = []

      expect { Team.new(name, on_call_engineer, services) }.to raise_error(ArgumentError)
    end
  end

  describe "#owns_service?" do
    it "returns true if service is owned" do
      owns = web_team.owns_service?("frontend")

      expect(owns).to be true
    end
    it "returns false if service is not owned" do
      expect(web_team.owns_service?("mobile")).to be false
    end
  end

  describe "#primary_service" do
    it "returns the first service if at least one service" do
      expect(web_team.primary_service).to eq "frontend"
    end
  end
end
