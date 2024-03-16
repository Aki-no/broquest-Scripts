#==============================================================================
# ** Main
#------------------------------------------------------------------------------
#  After defining each class, actual processing begins here.
#==============================================================================
begin
  # Prepare for transition
  $gigaczas = Time.now
  $DEBUG = true
  Graphics.freeze
  Graphics.frame_rate = 60
  Font.default_name = "BitPotionExt"
  Font.default_size = 40
  if !Dir.exist?(SAVEPATH)
    Dir.mkdir(SAVEPATH)
  end
  
  
  # Make scene object (title screen)
  $scene = Scene_RippedTitle.new
  $message = nil
  if File.exist?(SAVEPATH + "/save.rxdata")
    Autosave.new.read_save_data
    $game_system.bgm_play($game_system.playing_bgm)
    $game_system.bgs_play($game_system.playing_bgs)
    # Update map (run parallel process event)
    $game_map.update
    # Switch to map screen
    $scene = Scene_Map.new
  end
  $console = Console.new
  # Call main method as long as $scene is effective
  while $scene != nil
    $scene.main
  end
  # Fade out
rescue Errno::ENOENT
  # Supplement Errno::ENOENT exception
  # If unable to open file, display message and end
  filename = $!.message.sub("No such file or directory - ", "")
  print("Unable to find file #{filename}.")
end
