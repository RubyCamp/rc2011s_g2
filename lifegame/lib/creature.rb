class Creature
  attr_accessor :x, :y, :player_id, :hp

  def initialize(player_id, x, y)
    @player_id = player_id
    @x = x
    @y = y
    @hp = Game::DEFAULT_HP
  end

  def move!
    x, y = distance_of_move
    @x += x if 0 <= @x + x && @x + x <= Game::MAX_FIELD_SIZE[0] - 1
    @y += y if 0 <= @y + y && @y + y <= Game::MAX_FIELD_SIZE[1] - 1
  end

  def aging
    @hp -= 1
  end

  def eat
    @hp += 10
  end

  def fight
    @hp -= 3
  end

  private
  def distance_of_move
    x, y = 0, 0
    case (rand * 2).to_i
    when 0
      x = 1
    when 1
      x = -1
    when 2
      y = 1
    when 3
      y = -1
    end
    return [x, y]
  end
end
