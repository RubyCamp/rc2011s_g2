GameOverException = Class.new(StandardError)

class Client

  WINDOW_FPS = 60

  attr_accessor :server, :player_id, :data

  def initialize(uri)
    @server     = connect_server(uri)
    @player_id  = @server.add_player
    @player     = Player.new(@player_id)
    @data       = nil
    @loop_class = Game
    @turn       = 0
    @put_ruby_turn = 0
    @put_ruby_flag = false
    init_dxruby rescue nil
  end

  def start_loop
    @loop_class.loop do
    	begin
    		check_input
	      if @turn % WINDOW_FPS == 0
	      	pull
			    if is_start?
	      		push
	      		draw_gui
	      		put_ruby_sound
	      	else
	      		draw_gui_back
	      	end
	      end
	      @turn += 1
	      rescue GameOverException
	    	draw_game_over
	    end
    end
  end

  private
  def connect_server(uri)
    @server = DRbObject.new_with_uri(uri)
  end

  def is_start?
    !!@data[:turn]
  end

  def pull
    @data = @server.game_data
  end

  def push
    input = @player.input
    if input && @server.push_input(@player_id, input)
      @player.clear_input 
    end
  end
  
  def check_input
    if Input.mousePush?(M_LBUTTON)
      @player.input = Input.mousePosX, Input.mousePosY
      if @put_ruby_turn > Game::FOOD_INTERVAL
        @put_ruby_turn = 0
      end
      @put_ruby_flag = true
    end
  end
  
  def put_ruby_sound
    @put_ruby_turn += 1
    if @put_ruby_flag && @put_ruby_turn > Game::FOOD_INTERVAL
      @put_ruby_turn = 0
      @put_ruby_flag = false
      sound_file = File.join(File.expand_path("../../static/sounds", __FILE__), "kira.wav")
      Sound.new(sound_file).play
    end
    rescue
      nil
  end
  
  def init_dxruby
    @loop_class = Window
    Window.fps = WINDOW_FPS
    Window.width = 450
    Window.height = 450
    @font = Font.new(20)
    @image_path = File.expand_path("../../static/images", __FILE__)
  end

  def draw_cui
    result = ""
    @data[:field].each do |line|
      line.each do |point|
        result += point.to_s + " "
      end
      result += "\n"
    end
    result += "\n"
    puts result
    print "death: "; p @data[:death]
    print "birth: "; p @data[:birth]
  end

  def draw_gui
    draw_gui_back
    draw_gui_stat

    images = [
      nil,
      Image.load(File.join(@image_path, "ruby.png")),
      Image.load(File.join(@image_path, "man1.png")),
      Image.load(File.join(@image_path, "man2.png")),
    ]
    #XXX
    origin_x = 20
    origin_y = 20
    img_width = 20
    img_height = 20

    @data[:field].each.with_index do |line, x|
      line.each.with_index do |point, y|
        next if point == 0
        real_x = origin_x + x * img_width
        real_y = origin_y + y * img_height
        Window.draw(real_x, real_y, images[point])
      end
    end
  rescue
		draw_cui
    puts $@
    puts $!
  end

  def draw_gui_back
    Window.draw(0, 0, Image.load("#{@image_path}/backg.JPG"))
    draw_gui_border
  end
  
  def draw_gui_border
  	h  = Game::MAX_FIELD_SIZE[1]
  	w  = Game::MAX_FIELD_SIZE[0]
  	py = Game::PIXEL_SIZE[1]
  	px = Game::PIXEL_SIZE[0]
  	pdx = Game::PADDING_SIZE[0]
  	pdy = Game::PADDING_SIZE[1]
  	(w + 1).times do |x|
  		Window.draw_line(w * (x + 1), h, w * (x + 1), (h + 1) * py, [0, 0, 0])
  		Window.draw_line(w, h * (x + 1), (w + 1) * px, h * (x + 1), [0, 0, 0])
		end
  end 

	def draw_gui_stat
		Window.drawFont(0, 0, @data[:death].join(", "), @font)
	end
	
	def draw_game_over
		Window.drawFont(100, 100, "GAMEOVER", @font)
	rescue
		draw_cui_game_over
	end
	
	def draw_cui_game_over
		puts "GAMEOVER"
	end
end
