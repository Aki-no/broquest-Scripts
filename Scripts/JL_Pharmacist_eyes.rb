class Pharm_Eyes
  def initialize(x=320, y=160)
    @dir = 0  # 0down 1up 2left 3right
    @x = x
    @y = y
    @dir_vary = 60
    @sprite = Sprite.new
    @sprite.bitmap = Bitmap.new(640, 480)
    @sprite.z = 1
  end
  
  def update
    @sprite.tone = $game_screen.tone
    @sprite.bitmap.fill_rect(@x, @y, 2, 2, Color.new(0, 0, 0))
    case @dir
    when 0
      @y += 2
      dir_choices = [2, 3]
    when 1
      @y -= 2
      dir_choices = [2, 3]
    when 2
      @x -= 2
      dir_choices = [0, 1]
    when 3
      @x += 2
      dir_choices = [0, 1]
    end
    if rand(@dir_vary) == 0
      @dir = dir_choices[rand(2)]
      @dir_vary = 120
    else
      @dir_vary -= 1
    end
  end
  def dispose
    @sprite.dispose
  end
end

class Blood_Plode
  def initialize(x=332, y = 152, dir=-1)
    @x = x - (dir * 2)
    @y = y
    @y_vel = rand(0.700..1.000)
    @y_randomness = @y_vel
    @y_force = rand(0..6)
    @x_vel = rand(0.5..3.5) * dir
    @sprite = Sprite.new
    @sprite.bitmap = Bitmap.new(4, 4)
    darkness = rand(100..255)
    @sprite.bitmap.fill_rect(0, 0, rand(2..4), rand(2..4), Color.new(darkness, 0, 0))
    @sprite.z = 1
    @sprite.x = @x
    @sprite.y = @y
    @t = 0.5
  end
  def update
    @t += 0.05
    @y_vel = @t * @t * @y_randomness
    @y += @y_vel - @y_force
    @x += @x_vel
    @sprite.x = @x.round
    @sprite.y = @y.round
    #print(@y, @y_vel)
  end
end
