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
      @stations["#{s['s']}.#{s['min']}"] = station
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