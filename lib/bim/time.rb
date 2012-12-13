# Updates to the Time class
class Time
  def round(seconds = 60)
    Time.at((self.to_f / seconds).round * seconds)
  end

  def floor(seconds = 60)
    Time.at((self.to_f / seconds).floor * seconds)
  end
  
  # call such as Time.now.readable(30.minutes)
  def readable(seconds = 60) 
    Time.at((self.to_f / seconds).floor * seconds).strftime("%I:%M%p")
  end
  
  # call such as Time.now.readable_plus(30.minutes, 30)
  def readable_plus(seconds = 60, plus = 30)
    t = Time.now.floor(30.minutes) + plus.minutes
    t.readable(seconds)
  end
end