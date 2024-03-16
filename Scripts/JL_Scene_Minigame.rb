class Scene_Minigame
  attr_accessor :player
  attr_accessor :counter
  attr_accessor :location
  attr_accessor :particle_viewport
  attr_accessor :particles
  def initialize(battle=nil)
    @battle = battle
  end
  def main
    @node_spacing = 30
    @viewport = Viewport.new(320 - (@node_spacing * 3)/2, 240 - (@node_spacing * 3)/2, 640, 480)
    @viewport.z = 10
    @particle_viewport = Viewport.new(0, 0, 640, 480)
    @particle_viewport.z = 20
    draw_x = 0
    draw_y = 0
    @nodes = Sprite.new(@viewport)
    @nodes.bitmap = Bitmap.new(@node_spacing * 3, @node_spacing * 3)
    @player = Sprite.new(@viewport)
    @player.bitmap = Bitmap.new(20, 20)
    @player.bitmap.fill_rect(0, 0, 20, 20, Color.new(255, 255, 255))
    @counter = 35 * Graphics.frame_rate
    @counter_sprite = Sprite.new
    @counter_sprite.opacity = 25
    counter_string = (@counter / Graphics.frame_rate).ceil.to_s
    @counter_sprite.bitmap = Bitmap.new(640, 480)
    @counter_sprite.bitmap.font.size = 96
    @particles = []
    @hp_viewport = Viewport.new(0, 432, 144, 48)
    @hp_sprites = []
    3.times {@hp_sprites << Sprite.new(@hp_viewport)}
    offset = 0
    @hp_sprites.each do |b|
      b.bitmap = Bitmap.new("Graphics/miniga/heart.png")
      b.x = offset * 48
      offset += 1
    end
    @inv_frames = 0
    counter_update
    @location = 4
    @player.y = (@location / 3).floor * @node_spacing + ((@node_spacing / 2) - @player.bitmap.height / 2)
    @player.x = (@location % 3) * @node_spacing + ((@node_spacing / 2) - @player.bitmap.width / 2)
    @hp = 3
    9.times do
      @nodes.bitmap.fill_rect(draw_x + 12, draw_y + 12, 6, 6, Color.new(150, 150, 150))
      unless draw_x >= @node_spacing * 2
        draw_x += @node_spacing
      else
        draw_x = 0
        draw_y += @node_spacing
      end
    end
    @debug_counter = Sprite.new
    @debug_counter.bitmap = Bitmap.new(640, 13)
    loop do
      Graphics.update
      Input.update
      update
      if $scene != self
        break
      end
    end
  end
  def update
    @debug_counter.bitmap.clear
    @debug_counter.bitmap.fill_rect(0, 0, (@debug_counter.bitmap.width * (1 - (@counter / (35.0 * Graphics.frame_rate)))).round, @debug_counter.bitmap.height, Color.new(255, 255, 255))
    #print((@debug_counter.bitmap.width * (@counter / (35 * Graphics.frame_rate))).round)
    if @hp <= 0
      @counter = -1
    end
    @hp_viewport.ox = (3 - @hp) * 48
    if @counter <= 0
      $scene = Scene_Map.new
      $passed_minigame = true unless @hp <= 0
      dispose
      return
    end
    if Input.trigger?(Input::UP)
      if @location > 2
        @location -= 3
      end
    end
    if Input.trigger?(Input::DOWN)
      if @location < 6
        @location += 3
      end
    end
    if Input.trigger?(Input::LEFT)
      if !(@location % 3 == 0)
        @location -= 1
      end
    end
    if Input.trigger?(Input::RIGHT)
      if !(@location % 3 == 2)
        @location += 1
      end
    end
    @player.y = (@location / 3).floor * @node_spacing + ((@node_spacing / 2) - @player.bitmap.height / 2)
    @player.x = (@location % 3) * @node_spacing + ((@node_spacing / 2) - @player.bitmap.width / 2)
    if @inv_frames > 0
      @inv_frames -= 1
      if (@inv_frames / 10).odd?
        @player.visible = false
      else
        @player.visible = true
      end
    else
      @player.visible = true
    end
    case @battle
    when "kid"
      update_battle_kid
    end
    @counter -= 1
    counter_update
  end
  def counter_update
    
  end
  def hit
    unless @inv_frames > 0
      @hp -= 1
      @inv_frames = 60
      Audio.se_play("Audio/SE/" + "funnysound_crushed", 90, 100)
    end
  end
  def dispose
    @player.dispose
    @nodes.dispose
    @debug_counter.dispose
    @hp_viewport.dispose
    @particles.compact!
    @particles.each {|p| p.sprite.dispose}
  end
end