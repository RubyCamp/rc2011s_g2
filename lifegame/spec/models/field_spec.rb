require "spec_helper"

describe "Field" do
  it "create field" do
    field = Field.new(100, 100)
    field[0, 0][:creature1].should == []
  end

  it "parse to array2" do
    field = Field.new(2, 2)
    field.to_array2[0][0].should be_nil
  end

  it "parse to array2 if food exists" do
    field = Field.new(2, 2)
    field[0, 0][:food] << true
    field.to_array2[0][0].should == Field::NUM_FOOD
    field.to_array2[0][1].should be_nil
  end

  it "parse to array2 if food and creature exist" do
    field = Field.new(2, 2)
    field[0, 0][:food] << true
    field[0, 0][:creature1] << true
    field.to_array2[0][0].should == Field::NUM_FOOD
  end
end
