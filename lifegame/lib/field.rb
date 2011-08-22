class Field
  NUM_EMPTY     = 0
  NUM_FOOD      = 1
  NUM_CREATURE0 = 2
  NUM_CREATURE1 = 3

  def initialize(width, height)
    @xy = Array.new(width){ Array.new(height){
        {
          creature0: [],
          creature1: [],
          food: [],
        }
      }
    }
  end

  def [](x, y)
    @xy[x][y]
  end

  def to_array2
    result = @xy.map do |line|
      line.map do |point|
        if point[:food].size > 0
          NUM_FOOD
        elsif point[:creature0].size > 0
          NUM_CREATURE0
        elsif point[:creature1].size > 0
          NUM_CREATURE1
        else
          NUM_EMPTY
        end
      end
    end
  end
end
