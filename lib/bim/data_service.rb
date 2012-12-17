class DataService
  include HTTParty
  format :xml
  
  attr_reader :zip_code, :uuid, :providers, :default_provider, :current_provider, :selector_hash
  attr_writer :zip_code, :uuid, :providers, :default_provider, :current_provider, :selector_hash
  
  
  def initialize(zip_code, uuid, session, default_provider_id = nil) 
    @zip_code = zip_code
    @uuid = uuid
    @providers = Array.new
    @session = session
    
    register_user_xml = register_user
    setProviders(register_user_xml, default_provider_id)
    setSelectorHash()
  end
  
  def register_user
    puts "register_user() in DataService"
    @register_user_url = "http://iwavit.data.titantv.com/dataservice.asmx/RegisterUser?UUID=#{@uuid}&ZipCode=#{@zip_code}"
    ParseUrlXml.get(@register_user_url)
  end
  
  def request_lineup_data
    puts "request_lineup_data() in DataService"
    @request_lineup_data_url = "http://iwavit.data.titantv.com/dataservice.asmx/RequestLineupData?ProviderID=#{@current_provider.provider_id}&UUID=#{@uuid}"
    ParseUrlXml.get(@request_lineup_data_url)
  end
  
  # TODO: Set this up to get future times and dates. Currently does only current
  def request_program_slice(minutes = 180) 
    puts "request_program_slice() in DataService"
    now = Time.now.utc.floor(30.minutes).utc.to_s
    current_date = now[0..9]
    current_time = now[11..15]
    @request_program_slice_url = "http://iwavit.data.titantv.com/dataservice.asmx/RequestProgramDataSlice?UUID=#{@uuid}&ProviderID=#{@current_provider.provider_id}&StartDate=#{current_date}&StartTime=#{current_time}&NumberOfMinutes=#{minutes}"
    ParseUrlXml.get(@request_program_slice_url);
  end
  
  def get_basic_programs()
    puts "get_basic_programs() in DataService"
    @current_provider.program_schedules.each {  |schedule| 
      # raise TypeError, schedule
      # @current_provider.stations[schedule.station_id].programs.push(@current_provider.programs[schedule.program_id])
      
      program = @current_provider.programs[schedule.program_id]
      options = Hash.new
      options["id"] = schedule.program_id
      options["title"] = program.title
      options['episode_title'] = program.episode_title
      options['start_time_from_now'] = schedule.start_time_from_now
      options['end_time_from_now'] = schedule.end_time_from_now
      options['start_time_utc'] = schedule.start_time_utc
      options['end_time_utc'] = schedule.end_time_utc
      pf = ProgramFull.new(options)
      pf.setDuration(pf.end_time_from_now, pf.start_time_from_now)
      @current_provider.stations[schedule.station_id].programs.push(pf)
    }
     # raise TypeError, @current_provider
  end
  
  
  # TODO: Make this more efficient or whatever
  def request_program_details()
    puts "request_program_details() in DataService"
    # raise TypeError, @current_provider.program_schedules
    # raise TypeError, @current_provider.stations
    
    @current_provider.program_schedules.each {  |schedule| 
      if (true)
        # return;
        # raise TypeError, schedule
      end
      # schedule = @current_provider.program_schedules[4]
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
      begin
        station = @current_provider.stations[schedule.station_id]
        station.programs.push(p)
      rescue
        #raise TypeError, "#{station}, \n#{@current_provider.stations}, \n#{@current_provider}"
        puts "Caught an error. request_program_details() in DataService.rb"
      end
      # raise TypeError, station
      # raise TypeError, @current_provider.stations
    }
    
    # raise TypeError, @current_provider.stations
  end
  
  # Fills out hash of provider types -> Array(descriptions)
  def setSelectorHash
    puts "setSelectorHash() in DataService"
    providers = @providers
    types = (providers.map { |p| p.service_type }).uniq
    type_hash = Hash.new
    types.each { |type|
      type_hash[type.capitalize] = (providers.map { |p| 
        if (p.service_type == type)
          p.description 
        end
      }).compact
    }
    @selector_hash = type_hash
  end
  
  
    
  
  def to_s
    "DataService: {zip: #{@zip_code}, {uuid: #{@uuid}}, {current_provider: #{@current_provider}}"
  end
  
  # Takes in xml from register user call, gets providers, sets default
  def setProviders(xml, default_provider_id = nil)
    puts "setProviders() in DataService"
    providers = xml['ProviderDataReturn']['ProviderRecord']
    providers.each { |p|
      provider = Provider.new(p['ProviderId'], p['ServiceType'], p['Description'], p['City']);
     
      if (provider.service_type == "digital" && default_provider_id.nil?) 
        @default_provider = provider
        @current_provider = provider
      end
      
      if (provider.provider_id == default_provider_id) 
        @current_provider = provider
      end
      
      # puts "#{provider.provider_id}, #{default_provider_id}"
      @providers.push(provider)
    }
    
   
    lineup_data_xml = request_lineup_data
    @current_provider.createStations(lineup_data_xml)
    
    program_data_xml = request_program_slice(180)
    @current_provider.createPrograms(program_data_xml)
    @current_provider.createProgramSchedules(program_data_xml)
  
    get_basic_programs()
    # request_program_details()
    
    #raise TypeError, @current_provider.program_schedules
 
    # prints out everything we know, except for detailed program information
    #raise TypeError, to_s()
  end
  
  def setProvider(options) 
    puts "setProvider() in DataService"
    type = options[:type]
    desc = options[:desc]
    id = options[:id]
    #raise provider_id, TypeError
    #raise TypeError, "#{type}, #{desc}, #{@providers}"
    @providers.each { |p| 
      if ( (p.service_type == type.downcase && p.description == desc) || (p.provider_id == id) )
        @current_provider = p
        break
      end  
    }
    
    @current_provider.stations.clear
    @current_provider.programs.clear
    @current_provider.program_schedules.clear
    
    puts "---------DEBUG-------------"
    puts @current_provider
    puts "---------DEBUG-------------"
    
    lineup_data_xml = request_lineup_data()
    @current_provider.createStations(lineup_data_xml)
    
    program_data_xml = request_program_slice(180)
    @current_provider.createPrograms(program_data_xml)
    @current_provider.createProgramSchedules(program_data_xml)
  
    get_basic_programs()
    
    # raise TypeError, @current_provider
  end
end










