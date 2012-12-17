class Provider < DataService
  attr_reader :provider_id, :service_type, :description, :city, :stations, :programs, :program_schedules
  attr_writer :provider_id, :service_type, :description, :city
  @@blacklist = ['AT&T', 'ATT', 'MC', 'LOCAL', 'NHL', 'PPV', 'SHOPNG', 'DIRECTV', 'ADLT', 'SPOPRO', 'TEAM', 'MUSIC', 'ONDMD', 'INFO', 'INTLPROG', 'RADIO']

  
  def initialize(provider_id, service_type, description, city)
    @provider_id = provider_id
    @service_type = service_type
    @description = description
    @city = city
    #@stations = Array.new
    @stations = Hash.new
    @programs = Hash.new
    @program_schedules = Array.new
  end
  
  # Takes in xml from request lineup call, gets stations
  def createStations(xml)
    puts "createStations() in Provider"
    # raise TypeError, xml['LineupDataReturn']['St']
    stations = xml['LineupDataReturn']['St']
    stations.each { |s| 
      unless blacklisted?(s['cs'])
        station = Station.new(s['s'], s['cs'], s['rf'], s['n'], s['maj'], s['min'])
        @stations[s['s']] = station
      end
      # @stations.push(station)
      # raise TypeError, station
      # @stations[s['s']] = station
    }
    
    # raise TypeError, @stations
  end
  
  def createPrograms(xml) 
    puts "createPrograms() in Provider"
    programs = xml['ProgramDataReturn']['ProgramData']['Programs']['Pr']
    #raise TypeError, xml['ProgramDataReturn']['ProgramData']
    # raise TypeError, programs
    programs.each { |p| 
      options = Hash.new
      options["id"] = p['p']
      options["title"] = p['t']
      options['episode_title'] = p['te']
      
      program = Program.new(options)
      @programs[p['p']] = program
    }
    
    # raise TypeError, @programs
  end
  
  def createProgramSchedules(xml)
    puts "createProgramSchedules() in Provider"
    schedules = xml['ProgramDataReturn']['ProgramData']['Schedules']['Sc']
    schedules.each { |sc| 
      #raise TypeError, sc
      now_utc = Time.now.utc.floor(30.minutes)
      
      if (@stations[sc['s']])
        schedule = ProgramSchedule.new(sc['s'], sc['p'], sc['st'], sc['et'], now_utc.advance(:minutes => sc['st'].to_i), now_utc.advance(:minutes => sc['et'].to_i))
        @program_schedules.push(schedule)
      end
      # raise TypeError, schedule  
    }
  end
  
  def to_s
    "Provider: id: #{@provider_id}, type: #{@service_type}, description: #{@description}, city: #{@city}, \nstations: [#{@stations}], \nprograms: [#{@programs}], \nschedules: [#{@program_schedules}]"
  end
  
  private 
    def blacklisted?(name)
      @@blacklist.each { |str| 
        return true if name.upcase.include?(str) #str.include?(name.upcase)  
      }
      
      puts name.upcase
      return false
    end
end