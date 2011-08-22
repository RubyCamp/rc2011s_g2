require "spec_helper"

describe "Creature" do
  it "initialize" do
    creature = Creature.new(0, 0, 0)
    creature.should be_true
  end
end
