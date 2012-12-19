class MediaLive
  attr_accessor :clazz, :media, :network, :channel, :start_time, :end_time
  def initialize(clazz, media, network, channel, start_time, end_time)
    @clazz = clazz
    @media = media
    @network = network
    @channel = channel
    @start_time = start_time
    @end_time = end_time
  end
  
  # We consider it == if the type (Movie, TvShow) matches, and the media source itself matches via ==
  def ==(another)
    return @clazz == another.clazz && @media == another.media #&& @network == another.network #&& @channel == another.channel && @start_time == another.start_time
  end
  
  def to_s
    "MediaLive: clazz: #{@clazz}, media: #{@media}, network: #{@network}, channel: #{@channel}, time: #{@start_time}-#{@end_time}"
  end
end