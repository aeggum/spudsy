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