require "rotten"
require "tmdb"
require 'amazon/ecs'
require 'httparty'
include Geokit::Geocoders

class WelcomeController < ApplicationController
  require 'bim/data_service'
  require 'bim/provider'
  require 'bim/station'
  require 'bim/program_schedule'
  require 'bim/program_full'
  require 'bim/program'
  require 'bim/parse_url_xml'
  require 'bim/time'
  Rotten.api_key = 'pykjuv5y44fywgpu2m7rt4dk'
  Tmdb::Tmdb.api_key = "8da8a86a8b272a70d20c08a35b576d50"
  Tmdb::Tmdb.default_language = "en"
  caches_action :geolocate, :expires_in => 1.hour
  before_filter :set_your_picks, :only => :index
  before_filter :geolocate, :only => :index
  # caches_action :index, :expires_in => 2.minutes
  before_filter :bim, :only => :index
  
  
  def index 
    # reset_session
    # now = Time.now.readable(30)
    #raise TypeError, now    
    @@hidden_since_rotate = Array.new;
    @provider_hash = @@provider_hash
    
    #raise TypeError, @@stations
    
  end
  
  # returns the your_picks section
  def your_picks
    #raise TypeError, "PICKS QUEUE: #{$picks_queue.size}, #{$picks_queue.next}"
    while (!$picks_queue.empty?)
      if ($your_picks.include?($picks_queue.next))
        $picks_queue.pop
      else 
        $your_picks.push($picks_queue.pop)
      end
    end
    respond_to do |format|
      format.html { render :partial => "your_picks", :locals => { :media => $your_picks} }
    end
  end
  
   # gets all providers available for this data source
  def get_providers
    type = params[:type]
    descs = @@provider_hash[type]
    respond_to do |format|
      format.html { render :partial => "provider_option", :locals => { :descs => descs } }
    end
  end
  
  # changes the current provider (will regenerate tv grid)
  def change_provider
    type = params[:type]
    desc = params[:desc]
    
    $your_picks.clear
    @@ds.changeProvider(type, desc)
    @stations = @@ds.current_provider.stations
    
    respond_to do |format|
      format.html { render :partial => "stations", :locals => { :stations => @stations } }
    end
   
  end
  
  # rotates the 'your picks' section either forwards or backwards by 6
  def rotate_picks 
    #puts "-------------------------------------------------------------------------------------"
    #puts params
    #puts "-------------------------------------------------------------------------------------"
    
    # can rotate forwards or backwards
    if (params[:forward] == "true")
      $picks_forward += 6
      @@your_picks.rotate!(6)
      if $picks_forward == @@your_picks.size
        add_more_picks()
        @@your_picks.rotate!(-6)
      end
    else
      $picks_forward -= 6
      @@your_picks.rotate!(-6)
    end
    
    respond_to do |format|
      # format.json { render :json => @your_picks }
      format.html { render :partial => "your_picks", :locals => { :media => @@your_picks} }
    end
    
    $your_picks = @@your_picks
    
    # $index = [0,@your_picks.length-6].max
#     
    # while $index < @your_picks.length do
      # for pick in @@hidden_since_rotate do
#         
          # if (@your_picks[$index].class.to_s == pick["media_type"] && @your_picks[$index].id.to_s == pick["media_id"]) 
            # @your_picks.delete_at($index)
            # $index -=1
          # end
      # end
      # $index +=1
    # end
    
    @@hidden_since_rotate = Array.new
    
  end
  
  # hides the media for the user, permanently
  def hide_media
    if params[:media_type] == "movies"
      mType = "Movie"
    else 
      mType = "TvShow"
    end
    
    # store the liked/hated variable in the table (for the user)
    if params[:like] == "true"
      liked = true
    else
      liked = false
    end
    
    # add the content to the HiddenUserMedia table
    current_user.hidden_user_medias.push(HiddenUserMedia.new( :user_id => current_user.id, 
                                                              :media_id => params[:media_id], 
                                                              :media_type => mType,
                                                              :liked => liked))
    h = Hash.new
    h["media_id"] = params[:media_id]
    h["media_type"] = mType;                                            
    @@hidden_since_rotate.push(h)
    
    $index = 0;
    while $index < @@your_picks.length do
        
        if (@@your_picks[$index].class.to_s == h["media_type"] && @@your_picks[$index].id.to_s == h["media_id"])
          puts "--------------------FUCK FUCK-----------------------" 
          @@your_picks.delete_at($index)
          $index == @@your_picks.length;
        end
   
      $index +=1
    end
    
    $your_picks = @@your_picks
    
    respond_to do |format|
      format.html { render :partial => "your_picks", :locals => { :media => @@your_picks} }
    end
    
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
  
  

  
  
  
  
  
  
  
  
  private 
    
    # Calls bim's service to get tv data; all is in @@ds
    def bim
      bim_uuid = "SPUDSYTEST0000000000000001"
      ds = DataService.new(session[:zip_code], bim_uuid, session)
      @@ds = ds
      @@provider_hash = ds.selector_hash
      @stations = ds.current_provider.stations
    end
    
    
    
    # Sets up various things for the controller
    def set_your_picks
      #@movies = Movie.all(:limit => 30)
      $picks_queue = Containers::PriorityQueue.new
      @@full_movies = Movie.find(:all, :order => 'spudsy_rating DESC', :limit => 100)
      @show_array = TvShow.all(:limit => 30)
      @movies = @@full_movies[0...30] #Movie.find(:all, :order => 'spudsy_rating DESC', :limit => 30)
      @@your_picks = Array.new
      @movie = @movies[0]
      @@your_picks.push(*@movies)
      
      
      
      if (current_user) 
        hidden_media =  current_user.hidden_user_medias.all
        hidden_ids = Array.new
        
        hidden_media.each do |media|
          hidden_ids.push(media.media_id)
        end
        
        index = 0;
        while index < @@your_picks.length
          pick = @@your_picks [index]
          index_of_pick = hidden_ids.index(pick.id)
          if (!index_of_pick.nil?) 
            if pick.class.to_s == hidden_media[index_of_pick].media_type
              @@your_picks.delete_at(index)
              index -=1
            end
          end
          index +=1;
        end
      end
      
      # @your_picks = @@your_picks
      $your_picks = Array.new
      $picks_forward = 0
    end
    
    
    
    # Does geolocation to find zip code, latitude and longitude; cached
    def geolocate
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
      session[:zip_code] = zip_code
      session[:latitude] = latitude
      session[:longitude] = longitude
    end
    
    
    
    # Adds 6 more movies to the movies list
    def add_more_picks 
      titles = @@your_picks.map { |m| m.name }.join ','
      num_added = 0;
      @@full_movies.each {  |m| 
        unless titles.include?(m.name) 
          @@your_picks.push(m)
          num_added += 1
            break if num_added == 6
        end
      }
      
    end
end

