
def fish_check
  fishing = $fishing.update
  if fishing == "l"
    $game_variables[1] = 0
    $game_variables[11] = 3
    $fishing = nil
    $game_map.refresh
  elsif fishing == "w"
    $game_variables[11] = 2
    $game_variables[1] = 0
    $fishing = nil
    $game_map.refresh
  end
end

def add_follower(follower)
  $game_map.followers.push(follower)
  $scene.spriteset.character_sprites.push(Sprite_Character.new($scene.spriteset.viewport1, follower))
end
def get_relative_hour
  t = Time.new
  h = t.hour
  m = t.min
  if h < 12
    h = 12 if h == 0
    period = "am"
  else
    period = "pm"
    h -= 12 if h > 12
  end
  m < 10 ? m = "0" + m.to_s : m = m.to_s
  h < 10 ? h = "0" + h.to_s : h = h.to_s
  return h + ":" + m + period
end



class Test_Circular_Motion
  def initialize
    @sprite = Sprite.new
    @sprite.z = 9999
    @sprite.bitmap = Bitmap.new(640, 480)
    @radius = rand(150) + 50
    @x = (640 / 2)
    @y = (480 / 2)
    @vel = 0.05 + (rand * 0.1 - 0.05)
    @rad = rand * 2 * Math::PI
  end
  def update
    @x = Math.cos(@rad) * @radius + $game_player.screen_x#($game_player.real_x / 4) - ($game_map.display_x / 4)
    @y = Math.sin(@rad) * @radius + $game_player.screen_y - 32#($game_player.real_y / 4) - ($game_map.display_y / 4)
    @sprite.bitmap.clear
    @sprite.bitmap.fill_rect(@x, @y, 5, 5, Color.new(0, 0, 0))
    @rad += @vel
    if @rad >= (Math::PI * 2)
      @rad - (Math::PI * 2)
    end
  end
end



def check_lines_of_dialogue
  array = Array.new(13)
  lines = 0
  for i in (0..9)
    array[i] = load_data("Data/Map00" + i.to_s + ".rxdata")
  end
  for i in (10..13)
    array[i] = load_data("Data/Map0" + i.to_s + ".rxdata")
  end
  h = 0
  for i in array
    array[h] = i.events.values
    h+=1
  end
  for i in array
    for x in i
      for j in x.pages
        indent = 0
        for k in j.list
          if k.code == 355
            l = k.parameters[0]
            indent_offset = 0
            loop do
              if j.list[indent + 1].code == 655
                l += j.list[indent + 1].parameters[0]
              else
                break
              end
              indent += 1
              indent_offset += 1
            end
            indent -= indent_offset
            if l.include?("Message.new")
              print(l)
              lines += 1
            end
          end
          indent += 1
        end
      end
    end
  end
  print(lines)
end
  
  
  
  
  
  
  
  
  