class Player

  attr_accessor :input

  def initialize(player_id)
    @player_id = player_id
  end
  
  def clear_input
  	@input = nil
  end

end
