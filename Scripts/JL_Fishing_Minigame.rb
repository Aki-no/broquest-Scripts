

class Fishing_Game
  attr_accessor :stagnate
  attr_accessor :fish_type
  def initialize(diff=0, fish=nil, stagnate=false)
    @difficulty = diff
    @fish_type = fish
    #x was 115 before
    @viewport = Viewport.new(480, 75, 45, 240)
    unless (49 - 10 * diff) < 25
      @counter = 49 - 10 * diff
    else
      @counter = 25
    end
    @sa_direction = rand(2)
    @sa_speed = rand * 5 + 1 + @difficulty
    @sa_goto_speed = @sa_speed 
    @sa_speed_counter = 0
    
    @fish_direction = rand(2)
    @fish_speed = rand * 9 + 1
    @fish_speed_changing = false
    @fish_speed_counter = 0
    @fish_desired_speed = 0
    
    @buzzer_counter = 0

    @leniency = 0
    @stagnate = stagnate
    
    @comments = [Caption_Fade.new("CATCH!")]
    @in_a_pinch = false
    @in_a_pincher = false
    @almost_there = false
    create_game
  end
  def create_game
    @unsafe_area = Sprite.new(@viewport)
    @unsafe_area.bitmap = Bitmap.new(40, 240)
    @unsafe_area.bitmap.fill_rect(0, 0, 40, 240, Color.new(255, 0, 0))
    @unsafe_area.z = 0
  
    @safe_area = Sprite.new(@viewport)
    sa_height = 100 - @difficulty * 20
    @safe_area.bitmap = Bitmap.new(40, 100)
    @safe_area.bitmap.fill_rect(0, 0, 40, 100, Color.new(0, 255, 0))
    @safe_area.y = rand(@unsafe_area.bitmap.height - sa_height + 1)
    @safe_area.z = 1
    
    @fish = Sprite.new(@viewport)
    
    if @fish_type == nil
      @fish.bitmap = Bitmap.new(40, 20)
      @fish.bitmap.fill_rect(0, 0, 40, 20, Color.new(0, 0, 255))

    else
      case @fish_type
      when 1
        @fish.bitmap = Bitmap.new("Graphics/miniga/fish1.png")
      when 2
        @fish.bitmap = Bitmap.new("Graphics/Pictures/fish2.png")
      end
    end
    @fish.z = 2
    @fish.y = rand(@unsafe_area.bitmap.height - @fish.bitmap.height + 1)
    
    @counter_s = Sprite.new(@viewport)
    @counter_s.bitmap = Bitmap.new(5, 240)
    @counter_s.x = 40
    @counter_s.bitmap.fill_rect(0, (240 - (@counter / 100.0) * 240).round, 5, ((@counter / 100.0) * 240).round, Color.new(255, 255, 255))
  end
  def update
    to_clear = []
    i = 0
    @comments.each do |c|
      c.update
      if c.sprite.opacity < 0
        to_clear << i
      end
      i += 1
    end
    to_clear.each do |c|
      @comments.delete_at(c)
    end
    if rand(300 - @sa_speed_counter - (@difficulty * 20)) == 0
      @sa_speed = rand * 5 + 1  + @difficulty
      @sa_speed_counter = 0
    end
    @sa_speed_counter += 1
    if not @fish_speed_changing
      if rand(300 - @fish_speed_counter - (@difficulty * 20)) == 0
        @fish_desired_speed = rand * 9 + 1
        @fish_speed_counter = -1 
        @fish_speed_changing = true
      end
      @fish_speed_counter += 1
    else
      if @fish_speed > @fish_desired_speed
        unless (@fish_speed - 0.05) < @fish_desired_speed
          @fish_speed -= 0.05
        else
          @fish_speed = @fish_desired_speed
          @fish_speed_changing = false
        end
      else
        unless (@fish_speed + 0.05) >= @fish_desired_speed
          @fish_speed += 0.05
        else
          @fish_speed = @fish_desired_speed
          @fish_speed_changing = false
        end
      end
    end
      
    case @sa_direction
    when 0
      if @safe_area.y + @sa_speed.round < @unsafe_area.bitmap.height - @safe_area.bitmap.height
        @safe_area.y += @sa_speed.round
      else
        @sa_direction = 1
        @safe_area.y = @unsafe_area.bitmap.height - @safe_area.bitmap.height
      end
    when 1
      if @safe_area.y - @sa_speed.round > 0
        @safe_area.y -= @sa_speed.round
      else
        @sa_direction = 0
        @safe_area.y = 0
      end
    end
    case @fish_direction
    when 0
      if @fish.y + @fish_speed.round < @unsafe_area.bitmap.height - @fish.bitmap.height
        @fish.y += @fish_speed.round
      else
        @fish_direction = 1
        @fish.y = @unsafe_area.bitmap.height - @fish.bitmap.height
      end
    when 1
      if @fish.y - @fish_speed.round > 0
        @fish.y -= @fish_speed.round
      else
        @fish_direction = 0
        @fish.y = 0
      end
    end
    if @counter < 25
      @viewport.ox = [-1, 1][rand(2)]
      @viewport.oy = [-1, 1][rand(2)]
    else
      @viewport.ox = @viewport.oy = 0
    end
    if Input.trigger?(Input::C) and (not @stagnate)
      if Rect.new(@fish.x, @fish.y, 40, @fish.bitmap.height).collide?(Rect.new(@safe_area.x, @safe_area.y, 40, @safe_area.bitmap.height))
        if @counter + (9 + (@difficulty * 1.3) + @leniency * 0.5) < 100
          @counter += (9 + (@difficulty * 1.3) + @leniency * 0.5)
          #used to be 3 * (3 - difficulty)
          @leniency += 1
          if @leniency == 9
            @comments << Caption_Fade.new("WHAT AN AMAZING COMBO!", xy=[502, 10], size=0.7, color=Color.new(0, 255, 0))
          end
        else
          @counter = 100
          dispose
          return "w"
        end
      else
        if @counter > 0
          if @counter > 25
            @counter -= 10 + (@difficulty * 0.1)
          else
            @counter -= @counter * 0.3
          end
          @buzzer_counter = 10
        else
          @counter = 0
          dispose
          return "l"
        end
        @leniency = 0
      end
    else
      if @counter > 0
        @counter -= 0.12 + @difficulty * 0.075 unless @stagnate
      else
        dispose
        return "l"
        @counter = 0
      end
    end
    if @counter >= 75
      unless @almost_there
        @almost_there = true
        texts = ["ALMOST THERE!", "JUST A BIT MORE!", "YOU CAN DO IT!", "!!!!!!!!!!", "SO CLOSE", "SHOW IT WHO'S BOSS",
          "THAT ALL YOU'VE GOT?!", "HOME STRETCH!", "CATCH THAT THING!", "ANGLER?? BARELY KNOW HER"]
        @comments << Caption_Fade.new(texts[rand(texts.length)], xy=[502, 10], size=0.7, color=Color.new(255, 255, 0)) unless @leniency == 9
      end
    else
      @almost_there = false
      if @counter <= 10
        unless @in_a_pincher
          @in_a_pincher = true
          texts = ["QUICK!!!!!!", "WHAT ARE YOU DOING????", "no seriously what are you doing",
            "IT'S ESCAPING!", "HURRY!", "PULL!!!!!!!!!!!!!!", "MAKE HASTE, NOW!", "are you even listening"]
          @comments << Caption_Fade.new(texts[rand(texts.length)], xy=[502, 10], size=0.7, color=Color.new(255, 5, 5))
        end
      else
        @in_a_pincher = false
        if @counter <= 25
          unless @in_a_pinch
            @in_a_pinch = true
            texts = ["QUICK!", "PULL!!!", "DON'T LET IT ESCAPE!", "UMM...", 
              "IT'S GETTING DANGEROUS!", "DON'T JUST FOOL AROUND!", "ON YOUR FEET!", "NOW!"]
            @comments << Caption_Fade.new(texts[rand(texts.length)], xy=[502, 10], size=0.7, color=Color.new(155, 5, 5))
          end
        else
          @in_a_pinch = false
        end
      end
    end
    @counter_s.bitmap.clear
    if @buzzer_counter > 0
      color = Color.new(186, 186, 186)
      @buzzer_counter -= 1
    else
      color = Color.new(255, 255, 255)
    end
    @counter_s.bitmap.fill_rect(0, (240 - (@counter / 100.0) * 240).round, 5, ((@counter / 100.0) * 240).round, color)
    return true
        
  end
  def dispose
    @viewport.dispose
  end
end
    
class Caption
  def initialize(caption="Lv. 1 Carp", xy=[320, 340], color=Color.new(255, 255, 255), size=1.2, center=true)
    @caption = caption
    @xy=xy
    @color = color
    @size = size
    @center = center
    make_caption
  end
  def make_caption
    bitmap = Bitmap.new(640, 200)
    bitmap.font = Font.new("BitPotionExt")
      bitmap.font.size = 72
    bitmap.font.color = @color
    @sprite = Sprite.new
    @sprite.bitmap = bitmap
    @sprite.bitmap.draw_text(bitmap.rect, @caption)
    @text_area = @sprite.bitmap.text_size(@caption)
    @sprite.zoom_x = @sprite.zoom_y = @size
    if @center
      @sprite.x = @xy[0] - (@text_area.width  * @sprite.zoom_x / 2)
      @sprite.y = @xy[1] - (@text_area.height * @sprite.zoom_y  / 2)
    else
      @sprite.x = @xy[0]
      @sprite.y = @xy[1]
    end
    @sprite.z = 6000
  end
  def dispose
    @sprite.dispose
  end
end


class Flashy_Caption < Caption
  def initialize(caption="You Got A Catch!!", xy=[320, -72], color=Color.new(255, 255, 255), size=1.5,
    flash_color=Color.new(255, 255, 0), flash_interval=5)
    super(caption, xy, color, size)
    @flash_color = flash_color
    @flash_interval = flash_interval
    @flash_counter = @flash_interval
    @is_base_color = true
  end
  def update
    if @flash_counter <= 0
      @is_base_color ? color=@flash_color : color=Color.new(255, 255, 255) 
      @sprite.bitmap.clear
      @sprite.bitmap.font.color = color
      @sprite.bitmap.draw_text(@sprite.bitmap.rect, @caption)
      @is_base_color = (not @is_base_color)
      @flash_counter = @flash_interval
    else
      @flash_counter -= 1
    end
  end
end


class Caption_Fade < Caption
  attr_accessor :sprite
  def initialize(caption="SWEET!", xy=[502, 10], size=0.7, color=Color.new(255, 255, 255))
    super(caption, xy, color, size)
    @opacity = 300
  end
  def update
    @sprite.zoom_x -= 0.01
    @sprite.zoom_y -= 0.01
    @opacity -= 5
    @sprite.opacity -= 10 unless @opacity > 255
    @sprite.x = @xy[0] - (@text_area.width  * @sprite.zoom_x / 2)
    #@sprite.y = @xy[1] - (@text_area.height * @sprite.zoom_y  / 2)
  end
end
    
    
    
    
    
    
    
    
    
    
    
    
    
    