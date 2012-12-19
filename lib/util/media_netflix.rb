class MediaNetflix
  attr_accessor :clazz, :media
  def initialize(clazz, media)
    @clazz = clazz
    @media = media
  end
  
  def ==(another)
    return @clazz = another.clazz && @media == another.media
  end
  
  def to_s
    "MediaNetflix: clazz: #{@clazz}, media: #{@media}"
  end
end