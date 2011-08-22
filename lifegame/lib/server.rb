class Server
  MAX_PLAYER_COUNT = 2

  def initialize
    @players = []
    @player_samples = ["East", "West"]
  end

  def start_loop
    turn_loop { break if is_ready? }
    init_game
    turn_loop { next_turn }
  end

  def add_player
    validate_max_players!
    @players << @player_samples.shift
    return @players.size - 1
  end

  def game_data
    data = @game ? @game.data : {}
    return data
  end
  
  def push_input(player_id, input)
    return @game.push_input(player_id, input)
  end

  def is_start?
    !!@game
  end

  private
  def turn_loop
    loop do
      yield
      sleep 1
    end
  end

  def init_game
    @game = Game.new
  end

  def next_turn
    @game.next_turn
  end

  def validate_max_players!
    raise "MAX PLAYER COUNT" if @players.size >= MAX_PLAYER_COUNT
  end

  def is_ready?
    @players.size == 2
  end
end
