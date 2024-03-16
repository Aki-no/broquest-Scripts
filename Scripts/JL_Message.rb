SKIPS = [" "]

class Message
  attr_accessor :sprite
  attr_accessor :original_x
  def initialize(t, v, speaker_id=0, skippable=true, x=320, y=400, padding_color=Color.new(0, 0, 0, 255), text_color=Color.new(255, 255, 255, 255), abrupt=false)
    @sprite = Sprite.new
    @sprite.bitmap = Bitmap.new(800, 100)
    @sprite.x = x
    @original_x = x
    @sprite.y = y
    @sprite.z = 9998
    @padding = Sprite.new
    @padding.bitmap = Bitmap.new(800, 100)
    @padding.x = x
    @padding.y = y + 40
    @padding.z = 5000
    @padding.bitmap.fill_rect(0, 0, 20, 25, padding_color)
    @padding_color = padding_color
    @sprite.bitmap.font.color = text_color
    @text_x = 0
    @t = t.delete "\n"
    @v = v
    @skip = skippable
    @skip_it = false
    @speaker_id = speaker_id
    @text_index = 0
    @timer = 0
    @render_mult = false
    @awaiting_input = false
    @abrupt = abrupt
    $displaying_message = true
    @drunk_timer = 1
    @y_offset = 0
    @pitch_offset = 0
  end
  def update
    if $game_switches[5]
      if @drunk_timer > 0
        @drunk_timer -= 1
      else
        @sprite.x = rand(640)
        @sprite.y = rand(480)
        random_color
        @drunk_timer = 1
      end
    end
    if !@awaiting_input
      if (@skip and Input.trigger?(Input::C)) or ($DEBUG and Input.press?(Input::CTRL))
        @v = 0
        @skip_it = true
      end
      if @timer <= 0
        char = @t[@text_index]
        if !SKIPS.include?(char) and !@skip_it and @speaker_id != 0
          if char == "?"
            @pitch_offset = 3
          else
            @pitch_offset = 0
          end
          case @speaker_id
          # player
          when 1
            Audio.se_play("Audio/SE/player_talk.wav", 90, rand(99..101) +  @pitch_offset)
          # pharmacist
          when 2
            Audio.se_play("Audio/SE/talk_doc.wav", 100, rand(99..101) +  @pitch_offset)
          # caveman
          when 3
            Audio.se_play("Audio/SE/talk_caveman.wav", 50, rand(98..102) +  @pitch_offset)
            @y_offset = rand(6)
            oldman_cl = 150 + rand(116)
            @sprite.bitmap.font.color = Color.new(oldman_cl, oldman_cl, oldman_cl, 255)
          # rainbow guy
          when 4
            random_color
            voices = ["player_talk.wav", "talk_doc.wav", "talk_caveman.wav"]
            Audio.se_play("Audio/SE/" + voices[rand(voices.length)], 50 + rand(41), 50 + rand(101))
          # ?
          when 5
            if rand(2) > 0
              Audio.se_play("Audio/SE/player_talk.wav", 90, rand(101..115))
            else
              Audio.se_play("Audio/SE/player_talk.wav", 90, rand(99..101))
            end
          # kid 1 (high pitch)
          when 6
            Audio.se_play("Audio/SE/talk_kid.wav", 100, rand(100..105) +  @pitch_offset)
          # kid 2 (mid pitch)
          when 7
            Audio.se_play("Audio/SE/talk_kid.wav", 100, rand(95..102) +  @pitch_offset)
          # kid 3 (low pitch)
          when 8
            Audio.se_play("Audio/SE/talk_kid.wav", 100, rand(90..95) +  @pitch_offset)
          # player + reverb
          when 9
            Audio.se_play("Audio/SE/player_talk_reverb.wav", 90, rand(99..101) +  @pitch_offset)
          when 10
            #fisherman
            Audio.se_play("Audio/SE/player_talk.wav", 90, 50)
          end
        end
        @timer = @v unless SKIPS.include?(char)
        @sprite.bitmap.draw_text(@text_x, @y_offset, 640, 100, char)
        @sprite.x = @original_x - (@sprite.bitmap.text_size(@t[0..@text_index]).width / 2.0)
        @padding.x = @sprite.x - 20
        @padding.bitmap.fill_rect(@text_x + 20, 0, @sprite.bitmap.text_size(char).width + 17, 25, @padding_color)
        @text_x += @sprite.bitmap.text_size(char).width
        @text_index += 1
        if @text_index >= @t.length
          @awaiting_input = true
          return
        end
      else
        @timer -= 1
      end
      if @skip_it
        update
      end
      if @v < 0 and !@render_mult
        @render_mult = true
        @v.abs.times do
          update
        end
        @render_mult = false
      end
    else
      process_input
    end
  end
  def random_color
    r, g, b = rand(255), rand(255), rand(255)
    if r and g and b != 255
      case rand(3)
      when 0
        r = 255
      when 1
        g = 255
      when 2
        b = 255
      end
    end
    @sprite.bitmap.font.color = Color.new(r, g, b, 255)
  end
  def process_input
    if (Input.trigger?(Input::C) or @abrupt) or ($DEBUG and Input.press?(Input::CTRL))
      dispose
    end
  end
  def dispose
    @sprite.dispose
    @padding.dispose
    $displaying_message = false
  end
end