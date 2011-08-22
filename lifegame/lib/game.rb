class Game
  MAX_FIELD_SIZE       = [20, 20]
  FIRST_CREATURE_COUNT = 10
  FIRST_FOOD_COUNT     = 10
  SLEEP_SEC						 = 1
  FOOD_INTERVAL        = 0
  PIXEL_SIZE					 = [20, 20]
  PADDING_SIZE         = [20, 20]
  POPULATION_RATE      = 0.97
  DEFAULT_HP           = 20
  
  def self.loop
  	loop do
  		yield
  		sleep SLEEP_SEC
  	end
  end

  def initialize
    @turn = 0
    @field = Field.new(*MAX_FIELD_SIZE)
    @creatures = Array.new(2){ Array.new }
    @death = [0, 0]
    @birth = [0, 0]
    @food_turn = [FOOD_INTERVAL, FOOD_INTERVAL]
    init_creatures
    init_foods
  end

  def next_turn
    step_creatures
    check_gameover
    @turn += 1
    @food_turn[0] += 1
    @food_turn[1] += 1
  end

  def data
    return {
      turn: @turn,
      field: @field.to_array2,
      death: @death,
      birth: @birth,
    }
  end

  def push_input(player_id, input)
    real_x, real_y = input
    if @food_turn[player_id] > FOOD_INTERVAL
    	x, y = pixel_to_field(real_x, real_y)
    	if is_in_field?(x, y)
    		put_food(x, y)
    		clear_turn(player_id)
    		return true
    	end
    end
    return false
  end

  private
  def check_gameover
  	size0 = @creatures[0].size
  	size1 = @creatures[1].size
  	return false if size0 > 0 && size1 > 0
  	
  	#raise GameOverException.new(0)
  	if size0 > 0
  		return 0
  	elsif size1 > 0
  		return 1
  	else
  		return 2
  	end
  end
  
  def create_creature(player_id)
    x, y = [0, 1].map{|i| (0 .. MAX_FIELD_SIZE[i] - 1).to_a.sample }
    creature = Creature.new(player_id, x, y)
    @creatures[player_id] << creature
    @field[x, y][:"creature#{player_id}"] << creature

    @birth[player_id] += 1
  end

  def init_creatures
    2.times do |i|
      FIRST_CREATURE_COUNT.times do |j|
        create_creature(i)
      end
    end
  end

  def init_foods
    FIRST_FOOD_COUNT.times do |i|
      x, y = [0, 1].map{|i| (0 .. MAX_FIELD_SIZE[i] - 1).to_a.sample }
      @field[x, y][:food] << true
    end
  end

  def step_creatures
    [0, 1].each do |pid|
      @creatures[pid].select! do |creature|
        move(creature)
        act(creature)
        aging(creature)
      end
    end
  end

  def move(creature)
    old_xy = [creature.x, creature.y]
    @field[*old_xy][:"creature#{creature.player_id}"].delete_if do |item|
      item == creature
    end

    creature.move!
    new_xy = [creature.x, creature.y]
    @field[*new_xy][:"creature#{creature.player_id}"] << creature
  end

  def aging(creature)
    creature.aging
    if creature.hp <= 0
      delete_creature(creature)
      return false
    else
      return true
    end
  end

  def delete_creature(creature)
    @field[creature.x, creature.y][:"creature#{creature.player_id}"].delete_if do |c|
      c == creature
    end
    @death[creature.player_id] += 1
  end

  def delete_food(x, y)
    @field[x, y][:food].pop
  end

  def put_food(x, y)
    @field[x, y][:food] << true
  end
  
  def clear_turn(player_id)
    @food_turn[player_id] = 0
  end
  
  def pixel_to_field(real_x, real_y)
  	return ((real_x - PADDING_SIZE[0]) / PIXEL_SIZE[0]),
  	  ((real_y - PADDING_SIZE[1]) / PIXEL_SIZE[1])
  end
  
  def is_in_field?(x, y)
    (0...MAX_FIELD_SIZE[0]).include?(x) &&
    (0...MAX_FIELD_SIZE[1]).include?(y)
  end
  
  def act(creature)
    objects = find_arround(creature)
    eat(creature, *objects[:food]) if objects[:food]
    create_creature_random(creature) if objects[:"creature#{creature.player_id}"]
    creature.fight if objects[:"creature#{1 - creature.player_id}"]
  end

  def create_creature_random(creature)
    create_creature(creature.player_id) if (rand) > POPULATION_RATE
  end

  def eat(creature, x, y)
    creature.eat
    delete_food(x, y)
  end

  def find_arround(creature)
    objects = {}
    (-1..1).each do |x|
      (-1..1).each do |y|
        [:creature0, :creature1, :food].each do |object|
          object_x, object_y = creature.x - x, creature.y - y
          if (0 <= object_x && object_x <= MAX_FIELD_SIZE[0] - 1) &&
            (0 <= object_y && object_y <= MAX_FIELD_SIZE[1] - 1) &&
            (@field[object_x, object_y][object].size > 0) then
            objects[object] = [object_x, object_y]
          end
        end
      end
    end
    objects
  end
end
