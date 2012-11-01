movieArray = Array.new

# TODO: Generate the seeds file with the top movies, or whatever.

file1 = File.open("test2.rb", "r+")
  
if file1
  content = file1.sysread(10)
  puts content
else 
  puts "Unable to open file!"
end

