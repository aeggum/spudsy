
class Time
  def round(seconds = 60)
    Time.at((self.to_f / seconds).round * seconds)
  end

  def floor(seconds = 60)
    Time.at((self.to_f / seconds).floor * seconds)
  end
  
  def readable(seconds = 60)
    t = Time.at((self.to_f / seconds).floor * seconds)
    puts t 
    t.strftime("%I:%M%p")
  end
end