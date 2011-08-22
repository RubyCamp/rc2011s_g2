require "spec_helper"

describe "game" do
  it "initialize" do
    game = Game.new
    game.should be_true
  end

  it "has foods and creatures" do
    game = Game.new
    has_food = false
    has_creature0 = false
    has_creature1 = false
    game.data[:field].each do |line|
      line.each do |point|
        has_food = true if point == Field::NUM_FOOD
        has_creature0 = true if point == Field::NUM_CREATURE0
        has_creature1 = true if point == Field::NUM_CREATURE1
      end
    end
    has_food.should be_true
    has_creature0.should be_true
    has_creature1.should be_true
  end
end
