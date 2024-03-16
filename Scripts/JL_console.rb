WHITE = Color.new(255, 255, 255)

class Console
  def initialize
    @caption = nil
  end
  def set(text)
    if @caption != nil
      @caption.dispose
      @caption = nil
    end
    if text.is_a?(Float)
      text = text.round(4)
    end
    @caption = Caption.new(text.to_s, [5, 0], WHITE, 0.5, false)
  end
end