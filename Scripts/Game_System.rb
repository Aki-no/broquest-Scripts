

class Range
  def include_range?(r)
    self.each {|e| if r.include?(e); return true end}
    return false
  end
end

class Rect
  def collide?(rect)
    return ((self.x..self.x + self.width).include_range?(rect.x..rect.x + rect.width)) && ((self.y..self.y + self.height).include_range?(rect.y..rect.y + rect.height))
  end
end
