require "rotten"
require "tmdb"
require 'amazon/ecs'
require 'httparty'
include Geokit::Geocoders

class WelcomeController < ApplicationController
  Rotten.api_key = 'pykjuv5y44fywgpu2m7rt4dk'
  Tmdb::Tmdb.api_key = "8da8a86a8b272a70d20c08a35b576d50"
  Tmdb::Tmdb.default_language = "en"
  before_filter :set_your_picks, :only => :index
  
  def index 
    bim_uuid = "SPUDSYTEST0000000000000001"

    # @movies = Movie.all(:limit => 30)
    # @show_array = TvShow.all(:limit => 25)
    # @your_picks = Array.new
    # @movie = @movies[0]
    
    
    # puts the entire array onto the end of the your picks 
    # @your_picks.push(*@movies)
    #@your_picks.push(*@show_array)
    
    #@your_picks.rotate(6) or however we want to do it
    
    ip = request.remote_ip
    location = IpGeocoder.geocode(ip)
    latitude = location.lat
    longitude = location.lng
    
    # if localhost, assume madison for now
    if (ip == "127.0.0.1")
      latitude = 43.0731
      longitude = -89.4011
    end
    
    ll = "#{latitude}, #{longitude}"
    res = Geokit::Geocoders::GoogleGeocoder.reverse_geocode ll
    full_address = res.full_address
    zip_code = res.zip
 
    DataService.new(zip_code, bim_uuid)
    # zip_code now holds the zip of the request
    
    reg_user_url = "http://iwavit.data.titantv.com/dataservice.asmx/RegisterUser?UUID=#{bim_uuid}&ZipCode=#{zip_code}"
    t = ParseUrlXml.get(reg_user_url)
    
    providers = t['ProviderDataReturn']['ProviderRecord']
    
    default_provider = nil;
    
    providers.each { |provider|
      puts provider['ServiceType']
      if provider['ServiceType'] == "digital"
        default_provider = provider;
      end
    }
    
    raise TypeError, default_provider;  #providers; #providers[2]['ServiceType']
        # {"ProviderId"=>"G_53706", "ServiceType"=>"digital", "Description"=>"ATSC (digital) Broadcast", "City"=>nil}
    request_lineup_data_url = "http://iwavit.data.titantv.com/dataservice.asmx/RequestLineupData?ProviderID=#{default_provider['ProviderId']}&UUID=#{bim_uuid}"
    test = ParseUrlXml.get(request_lineup_data_url)
   # raise TypeError, test
    
        
  end
  
  respond_to :html, :json
  def rotate_picks 
    @@your_picks.rotate!(6)
    @@your_picks.each do |pick|
     print pick.name + ","
    end
    respond_to do |format|
      # format.json { render :json => @your_picks }
      format.html { render :partial => "your_picks", :locals => { :media => @@your_picks} }
    end
    puts
    puts 
    @@your_picks.each do |pick|
      print pick.name + ","
    end
    @your_picks = @@your_picks
  end
  
  
  def details
    # This is a placeholder - users will be redirected to it when they are signed in, for now
    # alternatively,
    Amazon::Ecs.configure do |options|
      options[:associate_tag] = 'Spudsy Devs'
      options[:AWS_access_key_id] = 'AKIAIKFAMUN6RODAOVKA'
      options[:AWS_secret_key] = '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'
    end

    # options provided on method call will merge with the default options
    res = Amazon::Ecs.item_search('Seinfeld', {:response_group => 'Medium', :sort => 'salesrank'})
    @res = res
    @total_pages = @res.total_pages
    @first = @res.items.first
  end
  
  # called before the others in the class get going
  def set_your_picks
    #@movies = Movie.all(:limit => 30)
    @show_array = TvShow.all(:limit => 30)
    @movies = Movie.find(:all, :order => 'spudsy_rating DESC', :limit => 30)
    @@your_picks = Array.new
    @movie = @movies[0]
    @@your_picks.push(*@movies)
    @your_picks = @@your_picks
  end
  
  # TODO: Could get the next set of shows if user has cycled through all on main load..
  
  private 
    def test_bim
      include HTTParty
      format :xml
    end
  
    # put private methods here
end

class ParseUrlXml
  include HTTParty
  format :xml
end

class DataService
  include HTTParty
  format :xml
  
  attr_reader :zip_code, :uuid, :providers, :default_provider, :current_provider
  attr_writer :zip_code, :uuid, :providers, :default_provider, :current_provider
  
  
  def initialize(zip_code, uuid) 
    @zip_code = zip_code
    @uuid = uuid
    @providers = Array.new
    
    register_user_xml = register_user
    setProviders(register_user_xml)
    
    # Now in the setProviders() method
    # lineup_data_xml = request_lineup_data
    # @current_provider.createStations(lineup_data_xml)
    xml = request_program_slice(60)
    programs = xml['ProgramDataReturn']['ProgramData']['Programs']
    programs.each { |p|
        
    }
    
    
    # FIXME: Below is wrong.  First, want to add all shows (not associated to station), then station's array of shows
    # xml = request_program_slice(30)
    # @current_provider.stations.each { |station|
      # station.createPrograms(xml['ProgramDataReturn']['ProgramData']['Programs'])
    # }
    # raise TypeError, xml['ProgramDataReturn']['ProgramData']['Programs']
  end
  
  def register_user
    @register_user_url = "http://iwavit.data.titantv.com/dataservice.asmx/RegisterUser?UUID=#{@uuid}&ZipCode=#{@zip_code}"
    ParseUrlXml.get(@register_user_url)
  end
  
  def request_lineup_data
    @request_lineup_data_url = "http://iwavit.data.titantv.com/dataservice.asmx/RequestLineupData?ProviderID=#{@current_provider.provider_id}&UUID=#{@uuid}"
    ParseUrlXml.get(@request_lineup_data_url)
  end
  
  # TODO: Set this up to get future times and dates. Currently does only current
  def request_program_slice(minutes = 180) 
    now = Time.now.utc.to_s
    current_date = now[0..9]
    current_time = now[11..15]
    @request_program_slice_url = "http://iwavit.data.titantv.com/dataservice.asmx/RequestProgramDataSlice?UUID=#{@uuid}&ProviderID=#{@current_provider.provider_id}&StartDate=#{current_date}&StartTime=#{current_time}&NumberOfMinutes=#{minutes}"
    ParseUrlXml.get(@request_program_slice_url);
  end
  
  def request_program_details()
    # raise TypeError, @current_provider.program_schedules
    # raise TypeError, @current_provider.stations
    
    schedule = @current_provider.program_schedules[4]
    start_time = schedule.start_time_utc.to_s[0..-8]
    # raise TypeError, schedule
    request_program_details = "http://iwavit.data.titantv.com/dataservice.asmx/RequestProgramDetails?UUID=#{@uuid}&ProviderId=#{@current_provider.provider_id}&StationId=#{schedule.station_id}&StartTimeOfProgram=#{start_time}"
    xml = ParseUrlXml.get( URI.encode(request_program_details) )
    # raise TypeError, xml['ProgramDetailsReturn']['ProgramDetails']['Pr']
    program = xml['ProgramDetailsReturn']['ProgramDetails']['Pr']
    
    # Set up all of the default options for the Program
    options = Hash.new
    options["id"] = schedule.program_id
    options["title"] = program['t']
    options['episode_title'] = program['te']
    options['description'] = program['desc']
    options['langauge'] = program['lang']
    options['start_utc'] = program['st']
    options['duration'] = program['dur']
    options['hd'] = program['hd']
    options['new'] = (program['rpt'] == "Repeat"? false : true)
    options['ei'] =  false;
    options['year'] = program['yr'];
    options['original_air_date'] = program['oad']
    options['tv_rating'] = program['tv']
    options['mpaa_rating'] = program['mpaa']
    options['star_rating'] = program['star']
    options['genres'] = program['genre']
    options['cast'] = program['cast']
    
    p = Program.new(options)
    
    station = @current_provider.stations[schedule.station_id]
    station.programs.push(p)
    # raise TypeError, station
    raise TypeError, @current_provider.stations
    
  end
    
  
  def to_s
    "DataService: {zip: #{@zip_code}, {uuid: #{@uuid}}, {current_provider: #{@current_provider}}"
  end
  
  # Takes in xml from register user call, gets providers, sets default
  def setProviders(xml)
    providers = xml['ProviderDataReturn']['ProviderRecord']
    providers.each { |p|
      provider = Provider.new(p['ProviderId'], p['ServiceType'], p['Description'], p['City']);
     
      if (provider.service_type == "digital") 
        @default_provider = provider
        @current_provider = provider
      end
      
      @providers.push(provider)
    }
    
    lineup_data_xml = request_lineup_data
    @current_provider.createStations(lineup_data_xml)
    
    program_data_xml = request_program_slice(30)
    # @current_provider.createPrograms(program_data_xml)
    @current_provider.createProgramSchedules(program_data_xml)
    request_program_details()
    raise TypeError, @current_provider.program_schedules
 
    # prints out everything we know, except for detailed program information
    raise TypeError, to_s()
  end
end


class Provider < DataService
  attr_reader :provider_id, :service_type, :description, :city, :stations, :programs, :program_schedules
  attr_writer :provider_id, :service_type, :description, :city
  
  def initialize(provider_id, service_type, description, city)
    @provider_id = provider_id
    @service_type = service_type
    @description = description
    @city = city
    #@stations = Array.new
    @stations = Hash.new
    # @programs = Array.new
    @program_schedules = Array.new
  end
  
  # Takes in xml from request lineup call, gets stations
  def createStations(xml)
    # raise TypeError, xml['LineupDataReturn']['St']
    stations = xml['LineupDataReturn']['St']
    stations.each { |s| 
      station = Station.new(s['s'], s['cs'], s['rf'], s['n'], s['maj'], s['min'])
      # @stations.push(station)
      @stations[s['s']] = station
    }
    
    # raise TypeError, @stations
  end
  
  # def createPrograms(xml) 
    # programs = xml['ProgramDataReturn']['ProgramData']['Programs']['Pr']
    # # raise TypeError, xml['ProgramDataReturn']['ProgramData']['Schedules']['Sc']
    # # raise TypeError, programs
    # programs.each { |p| 
      # program = Program.new(p['p'], p['t'], p['te'])
      # @programs.push(program)
    # }
    # 
    # raise TypeError, @programs
  # end
  
  def createProgramSchedules(xml)
    schedules = xml['ProgramDataReturn']['ProgramData']['Schedules']['Sc']
    schedules.each { |sc| 
      #raise TypeError, sc
      now_utc = Time.now.utc
      schedule = ProgramSchedule.new(sc['s'], sc['p'], sc['st'], sc['et'], now_utc.advance(:minutes => sc['st'].to_i), now_utc.advance(:minutes => sc['et'].to_i))
      @program_schedules.push(schedule)
      # raise TypeError, schedule  
    }
  end
  
  def to_s
    "Provider: id: #{@provider_id}, type: #{@service_type}, description: #{@description}, city: #{@city}, \nstations: [#{@stations}], \nprograms: [#{@programs}], \nschedules: [#{@program_schedules}]"
  end
end

class Station < Provider
  attr_reader :station_id, :callsign, :rf_channel, :name, :major_channel, :minor_channel
  attr_writer :station_id, :callsign, :rf_channel, :name, :major_channel, :minor_channel
  
  def initialize(station_id, callsign, rf_channel, name, major_channel, minor_channel)
    @station_id = station_id
    @callsign = callsign
    @rf_channel = rf_channel
    @name = name
    @major_channel = major_channel
    @minor_channel = minor_channel
    @programs = Array.new
  end
  
  # Takes in xml from request program slice call, makes programs
  def createPrograms(xml)
    raise TypeError, xml
  end
  
  def to_s
    "\nStation: id: #{@station_id}, callsign: #{@callsign}, name: #{@name}, maj.min: #{@major_channel}.#{@minor_channel}, programs: #{@programs}"
  end
end


class Program < Station
  # Essentially a whitelist of all variables for the class
  attr_accessor :id, :title, :episode_title, :description, :language, :start_utc, :duration, :hd, :new, :ei, :year, :original_air_date, :tv_rating, :mpaa_rating, :star_rating, :genres, :cast_members
  
  def initialize(options = {})
    options.each { |key, value| 
      instance_variable_set("@#{key}", value)   
    }
  end
  
  def to_s
    str = "\nid: #{@id}, title: #{@title}, episode_title: #{@episode_title}, description: #{@description}, language: #{@language}, start: #{start_utc}, duration: #{@duration}, hd: #{@hd}, "
    str += "new: #{@new}, ei: #{@ei}, year: #{@year}, original_air_date: #{@original_air_date}, tv_rating: #{@tv_rating}, mpaa_rating: #{@mpaa_rating}, stars: #{@star_rating}, "
    str += "genres: #{@genres}, cast: #{@cast}"
    return str;
  end
 
end

class ProgramSchedule < Provider
  attr_reader :station_id, :program_id, :start_time_from_now, :end_time_from_now, :start_time_utc, :end_time_utc
  attr_writer :station_id, :program_id, :start_time_from_now, :end_time_from_now, :start_time_utc, :end_time_utc
  
  def initialize(station_id, program_id, start_time_from_now, end_time_from_now, start_time_utc, end_time_utc)
    #super(program_id, start_time_from_now, end_time_from_now, start_time_utc, end_time_utc)
    @station_id = station_id
    @program_id = program_id
    @start_time_from_now = start_time_from_now
    @end_time_from_now = end_time_from_now
    @start_time_utc = start_time_utc
    @end_time_utc = end_time_utc
  end
  
  def to_s
    "\nProgramSchedule: station_id: #{@station_id}, program_id: #{@program_id}, start(minutes): #{@start_time_from_now}, end(minutes): #{@end_time_from_now}, start: #{@start_time_utc}, end: #{@end_time_utc}"
  end
end
