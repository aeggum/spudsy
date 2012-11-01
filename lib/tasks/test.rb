require 'action_view'
include ActionView::Helpers::DateHelper

movieArray = Array.new

# TODO: Generate the seeds file with the top movies, or whatever.
# TODO: We'll want to do something similar to below, but put into seeds.rb

file1 = File.open("test2.rb", "r+")
  
if file1
  content = file1.sysread(10)
  puts content
else 
  puts "Unable to open file!"
end

# A pair of sample data that we would want to put into the seeds file
movieArray.push( 
  {:name => "foo", :rating => 100.0, :user_rating => 10.0, :description => "the first part of foobar", :mpaa_rating => "R", :release_date => DateTime.strptime("09/20/2010 8:00", "%m/%d/%Y %H:%M")}, 
  {:name => "bar", :user_rating => 200.0, :mpaa_rating => "PG-13", :description => "the other part of foobar", :rating => 99.0, :release_date => DateTime.strptime("09/20/2010 8:00", "%m/%d/%Y %H:%M")} 
)
puts movieArray

