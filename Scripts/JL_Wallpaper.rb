class Wallpaper
  def initialize
    @appdata = ENV['APPDATA']
    @wp = @appdata + "\\Microsoft\\Windows\\Themes\\TranscodedWallpaper"
  end
  def display
    @wallpaper = Sprite.new
    @wallpaper.bitmap = RPG::Cache.picture('wallpaper')
    @wallpaper.zoom_x = 640.0 / @wallpaper.bitmap.width
    @wallpaper.zoom_y = 480.0 / @wallpaper.bitmap.height
  end
  def copy
    if File.exist?(@wp + ".jpg")
      @wp = @appdata + "\\Microsoft\\Windows\\Themes\\TranscodedWallpaper.jpg"
    elsif !File.exist?(@wp)
      return false
    end
    begin
      File.open(SAVEPATH + "/wallpaper.jpg", "wb") {|f| f.write(File.open(@wp, "rb").read)}
    rescue
      return false
    end
    return true
  end
  def copied?
    return File.exist?(SAVEPATH + "/wallpaper.jpg")
  end
  def hide
    @wallpaper.visible = false
    @wallpaper = nil
    begin
      File.delete(SAVEPATH + "/wallpaper.jpg")
    end
  end
end