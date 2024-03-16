class Game_Follower < Game_Character
  attr_accessor :x, :y, :real_x, :real_y
  def initialize(mother = $game_player, sprite="player")
    super()
    @mother = mother
    reset
    @character_name = sprite
    @through = true
    @await_mother = false
    update
  end
    
  def update
    if @mother.moving? and !moving?
      case @remembered_move
      when 0
        @await_mother = true
      when 1
        move_down
      when 2
        move_up
      when 3
        move_left
      when 4
        move_right
      end
      if @remembered_move > 0
        @remembered_move = @mother.last_move
      end
    elsif @await_mother
      @remembered_move = @mother.last_move
      @await_mother = false
    end
    super
  end
  def check_event_trigger_touch(x, y)
  end
  def reset
    @x = @mother.x
    @y = @mother.y
    case @mother.direction
    when 2
      @y -= 1
      @remembered_move = 1
    when 4
      @x += 1
      @remembered_move = 3
    when 6
      @x -= 1
      @remembered_move = 4
    when 8
      @y += 1
      @remembered_move = 2
    end
    @real_y = @y * 128
    @real_x = @x * 128
  end
  def specific_reset(spawn_back=true, spawn_xy=[@mother.x, @mother.y])
    @x = spawn_xy[0]
    @y = spawn_xy[1]
    if spawn_back
      case @mother.direction
      when 2
        @remembered_move = 1
      when 4
        @remembered_move = 3
      when 6
        @remembered_move = 4
      when 8
        @remembered_move = 2
      end
    else
      case @mother.direction
      when 2
        @remembered_move = 2
      when 4
        @remembered_move = 4
      when 6
        @remembered_move = 3
      when 8
        @remembered_move = 1
      end
    end
    @real_y = @y * 128
    @real_x = @x * 128
  end
end