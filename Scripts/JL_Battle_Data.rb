class Battle_Particle
  attr_reader :x
  attr_reader :y
  attr_reader :sprite
  attr_reader :has_introduced
  def initialize(type, parameters)
    @type = type
    @sprite = Sprite.new($scene.particle_viewport)
    case @type
    when 1
      @sprite.bitmap = Bitmap.new(8, 8)
      @sprite.bitmap.fill_rect(0, 0, 8, 8, Color.new(255, 0, 0))
      @sprite.x = @x = parameters[0]
      @sprite.y = @y = parameters[1]
      @speed = parameters[2]
      @dir = parameters[3]
      @has_introduced = false
    end
  end
  def update
    case @type
    when 1
      case @dir #0down1up2left3right
      when 0
        @y += @speed
      when 1
        @y -= @speed
      when 2
        @x -= @speed
      when 3
        @x += @speed
      end
      @sprite.x = @x.round
      @sprite.y = @y.round
      player_rect = Rect.new(@sprite.x, @sprite.y, @sprite.bitmap.width, @sprite.bitmap.height)
      if !@has_introduced and player_rect.collide?(Rect.new(0, 0, 640, 480))
        @has_introduced = true
      end
      if player_rect.collide?(Rect.new($scene.player.x + 275, $scene.player.y + 195, $scene.player.bitmap.width, $scene.player.bitmap.height))
        $scene.hit
        @y = 640
      end
    end
  end
end



def update_battle_kid
  # time already passed in frames
  case 35 * Graphics.frame_rate - $scene.counter
  when 0
    Audio.bgm_play("Audio/BGM/forest_minigame", 100, 100)
  when 200
    $scene.particles << Battle_Particle.new(1, [316, -8, 3, 0])
  when 260
    $scene.particles << Battle_Particle.new(1, [-8, 236, 3, 3])
  when 300
    $scene.particles << Battle_Particle.new(1, [316, 480, 3, 1])
  when 320
    $scene.particles << Battle_Particle.new(1, [640, 236, 3, 2])
  when 460
    $scene.particles << Battle_Particle.new(1, [-8, 236, 3, 3])
    $scene.particles << Battle_Particle.new(1, [640, 236, 3, 2])
    $scene.particles << Battle_Particle.new(1, [316, 556, 3, 1])
    $scene.particles << Battle_Particle.new(1, [316, -84, 3, 0])
  end
  
  if Input.trigger?(Input::C)
    print($scene.particles)
  end
  
  # clear array of empty particles
  $scene.particles.compact!
  # update particles
  unless $scene.particles.empty?
    $scene.particles.each do |p|
      p.update
      # if particle outside the screen, clear it
      if (p.x > 640 or p.x < -p.sprite.bitmap.width or p.y > 480 or p.y < -p.sprite.bitmap.height) and p.has_introduced
        p.sprite.dispose
        $scene.particles[$scene.particles.index(p)] = nil
      end
    end
  end
end