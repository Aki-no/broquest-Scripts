class Particle < Sprite
  attr_accessor :running
  attr_accessor :sin
  attr_accessor :sin_direction
  attr_accessor :accel
  attr_accessor :sin_null
  attr_accessor :theoretical_x
  attr_accessor :wait_time
  def initialize(viewport)
    super(viewport)
    @running = false
    @sin = 1
    @sin_null = 0
    @sin_direction = true
    @accel = 0
    @wait_time = 0
    @theoretical_x = 0
  end
end

class Water_Droplets
  def initialize(frequency)
    @freq = frequency
    @layer = Array.new(frequency)
    @viewport = Viewport.new(0, 0, 640, 480)
    @viewport.z = 50
    @freq.times {|e| @layer[e] = create_particle}
  end
  def update
    tilemap = $scene.spriteset.tilemap
    @layer.each do |l|
      if l.wait_time > 0
        l.wait_time -= 1
      else
        l.accel += 0.234375
        l.y += l.accel.floor
        if l.y >= tilemap.map_data.ysize * 32
          @layer[@layer.index(l)] = create_particle
        end
      end
    end
    @viewport.ox = tilemap.ox
    @viewport.oy = tilemap.oy
  end
  def create_particle
    part = Particle.new(@viewport)
    part.bitmap = Bitmap.new(2, 2)
    part.wait_time = rand(361)
    brightness = 10 + rand(31)
    part.bitmap.fill_rect(0, 0, 2, 2, Color.new(brightness, brightness, 205 + brightness, 200 + rand(56)))
    part.x = rand($scene.spriteset.tilemap.map_data.xsize * 32)
    part.y = -2
    return part
  end
  def dispose
    @viewport.dispose
  end
end

class Dream_Particles
  def initialize(amount, type=0)
    @amt = amount
    @layer = Array.new(amount)
    @viewport = Viewport.new(0, 0, 640, 480)
    @viewport.z = 50
    @hide = false
    @type = type
    case type
    when 0
      @amt.times do |e|
        @layer[e] = Particle.new(@viewport)
        @layer[e].bitmap = Bitmap.new(2, 2)
        @layer[e].bitmap.fill_rect(0, 0, 2, 2, Color.new(255, 255, 255, 255))
        @layer[e].opacity = 0
      end
    when 1
      @chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890~`!@$^&*(){}[]_+-=:;|?/><,.#"
      @amt.times do |e|
        @layer[e] = Particle.new(@viewport)
        @layer[e].bitmap = Bitmap.new(30, 30)
        @layer[e].bitmap.draw_text(0, 0, 30, 30, @chars[rand(0..@chars.length - 1)])
        @layer[e].opacity = 0
      end
    end
  end
  def update
    if @hide
      return
    end
    @layer.each do |e|
      if e.running
        if e.y < 1
          e.running = false
          e.opacity = 0
        else
          if @type == 1
            if rand(0..3) == 0
              e.bitmap.clear
              e.bitmap.draw_text(0, 0, 30, 30, @chars[rand(0..@chars.length - 1)])
            end
          end
          if e.sin != 0
            if e.sin_direction and 
              if e.x > e.sin_null + e.sin
                e.sin_direction = false
              else
                e.theoretical_x += 0.5
                e.x = e.theoretical_x
              end
            else
              if e.x < e.sin_null - e.sin
                e.sin_direction = true
              else
                e.theoretical_x -= 0.5
                e.x = e.theoretical_x
              end
            end
          end
          if @type == 0
            e.y += (e.y * e.accel - e.y) * 0.25
          else
            e.y -= 5
          end
        end
      elsif rand(0..@amt + 10) == 0
        e.running = true
        e.x = rand(0..640)
        e.theoretical_x = e.x
        e.y = 481
        e.sin = rand(0..10)
        e.sin_null = e.x
        e.accel = rand(97..99) / 100.0
        e.opacity = rand(25..255)
      end
    end
  end
  def hide
    @viewport.visible = false
    @hide = true
  end
  def show
    @viewport.visible = true
    @hide = false
  end
end