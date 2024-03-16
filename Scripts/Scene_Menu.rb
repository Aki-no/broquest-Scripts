#==============================================================================
# ** Scene_Menu
#------------------------------------------------------------------------------
#  This class performs menu screen processing.
#==============================================================================

class Scene_Menu
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     menu_index : command cursor's initial position
  #--------------------------------------------------------------------------
  def initialize(menu_index = 0)
    @menu_index = menu_index
  end
  #--------------------------------------------------------------------------
  # * Main Processing
  #--------------------------------------------------------------------------
  def main
    @sprite = Sprite.new
    @sprite.bitmap = Bitmap.new(640, 480)
    @sprite.y = 0
    size_rect1 = @sprite.bitmap.text_size("U sure u wanna quit")
    size_rect2 = @sprite.bitmap.text_size("really if u havent saved then ur progress will be gone")
    size_rect3 = @sprite.bitmap.text_size("Press CONFIRM to quit or CANCEL to return.")
    @sprite.bitmap.draw_text(320 - size_rect1.width / 2, 0 - size_rect1.height / 2 - size_rect2.height, 640, 480, "U sure u wanna quit")
    @sprite.bitmap.font.color = Color.new(255, 0, 0, 255)
    @sprite.bitmap.draw_text(320 - size_rect2.width / 2, 0 - size_rect2.height / 2, 640, 480, "really if u havent saved then ur progress will be gone")
    @sprite.bitmap.font.color = Color.new(255, 255, 255, 255)
    @sprite.bitmap.draw_text(320 - size_rect3.width / 2, 0 - size_rect3.height / 2 + size_rect2.height + size_rect1.height, 640, 480, "Press CONFIRM to quit or CANCEL to return.")
    $game_system.bgm_vol(0.25)
    # Execute transition
    # Main loop
    loop do
      # Update game screen
      Graphics.update
      # Update input information
      Input.update
      # Frame update
      update
      # Abort loop if screen is changed
      if $scene != self
        break
      end
    end
    # Prepare for transition
    # Dispose of windows
    @sprite.dispose
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    if Input.trigger?(Input::C)
      $scene = nil
    elsif Input.trigger?(Input::B)
      $game_system.bgm_vol(4)
      $scene = Scene_Map.new
    end
  end
end
