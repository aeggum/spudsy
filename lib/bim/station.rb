class Station < Provider
  attr_reader :station_id, :callsign, :rf_channel, :name, :major_channel, :minor_channel, :programs2
  attr_writer :station_id, :callsign, :rf_channel, :name, :major_channel, :minor_channel, :programs2
  
  def initialize(station_id, callsign, rf_channel, name, major_channel, minor_channel)
    @station_id = station_id
    @callsign = callsign
    @rf_channel = rf_channel
    @name = name
    @major_channel = major_channel
    @minor_channel = minor_channel
    @programs = Array.new
    @programs2 = Array.new
   # @program_schedules = Array.new  not needed
  end
  
  # Takes in xml from request program slice call, makes programs
  def createPrograms(xml)
    raise TypeError, xml
  end
  
  def to_s
    "\nStation: id: #{@station_id}, callsign: #{@callsign}, name: #{@name}, maj.min: #{@major_channel}.#{@minor_channel}, programs: #{@programs2}" #, programs: #{@programs2}"
  end
end