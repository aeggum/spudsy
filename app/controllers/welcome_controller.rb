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
  require 'bim/program'
  require 'bim/parse_url_xml'
  Rotten.api_key = 'pykjuv5y44fywgpu2m7rt4dk'
  Tmdb::Tmdb.api_key = "8da8a86a8b272a70d20c08a35b576d50"
  Tmdb::Tmdb.default_language = "en"
  before_filter :set_your_picks, :only => :index
  before_filter :geolocate, :only => :index
  # caches_action :index, :expires_in => 2.minutes
  caches_action :geolocate, :expires_in => 2.hours
  # before_filter :tvdata, :only => :index
  
  
  def index 
    # reset_session

    # @movies = Movie.all(:limit => 30)
    # @show_array = TvShow.all(:limit => 25)
    # @your_picks = Array.new
    # @movie = @movies[0]
    
    # raise TypeError, session
    # puts the entire array onto the end of the your picks 
    # @your_picks.push(*@movies)
    #@your_picks.push(*@show_array)
    
    #@your_picks.rotate(6) or however we want to do it
    
    @@hidden_since_rotate = Array.new;
    #sleep 5;
    #Movie.all
    #raise TypeError, session[:data]
    

    
  end
  
  def tvdata
    
    bim_uuid = "SPUDSYTEST0000000000000001"
    ds = DataService.new(session[:zip_code], bim_uuid, session)
    # session[:testing] = ds.current_provider.stations
    #sleep 10;
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
    
    $index = [0,@your_picks.length-6].max
    
    while $index < @your_picks.length do
      for pick in @@hidden_since_rotate do
        
          if (@your_picks[$index].class.to_s == pick["media_type"] && @your_picks[$index].id.to_s == pick["media_id"]) 
            @your_picks.delete_at($index)
            $index -=1
          end
      end
      $index +=1
    end
    
    @@hidden_since_rotate = Array.new
    
  end
  
  def hide_media
    if params[:media_type] == "movies"
      mType = "Movie"
    else 
      mType = "TvShow"
    end
    
    if params[:like] == "true"
      liked = true
    else
      liked = false
    end
    
    current_user.hidden_user_medias.push(HiddenUserMedia.new( :user_id => current_user.id, 
                                                              :media_id => params[:media_id], 
                                                              :media_type => mType,
                                                              :liked => liked))
    h = Hash.new
    h["media_id"] = params[:media_id]
    h["media_type"] = mType;                                            
    @@hidden_since_rotate.push(h)
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
  
  # TODO: Could get the next set of shows if user has cycled through all on main load..
  
  private 
    
    # put private methods here
end

