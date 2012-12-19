require "rotten"
require "tmdb"
require 'amazon/ecs'
require 'httparty'
include Geokit::Geocoders

class WelcomeController < ApplicationController
  Dir[File.dirname(__FILE__) + '/lib/bim/*.rb'].each {|file| require file }
  Dir[File.dirname(__FILE__) + '/lib/util/*.rb'].each {|file| require file }
  Rotten.api_key = 'pykjuv5y44fywgpu2m7rt4dk'
  Tmdb::Tmdb.api_key = "8da8a86a8b272a70d20c08a35b576d50"
  Tmdb::Tmdb.default_language = "en"
  before_filter :set_your_picks, :only => :index
  before_filter :test_for_cookies, :only => :index
  # before_filter :geolocate, :only => :index
  # caches_action :index, :expires_in => 2.minutes
  # before_filter :bim, :only => :index
  
  
  def index
    puts "index() in WelcomeController"
    $hidden_since_rotate = Array.new;
    #raise TypeError, $ds
  end
  
  def details
    puts "details() in WelcomeController"
    # This is a placeholder - users will be redirected to it when they are signed in, for now
    # alternatively,
    # Amazon::Ecs.configure do |options|
      # options[:associate_tag] = 'Spudsy Devs'
      # options[:AWS_access_key_id] = 'AKIAIKFAMUN6RODAOVKA'
      # options[:AWS_secret_key] = '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'
    # end
# 
    # # options provided on method call will merge with the default options
    # res = Amazon::Ecs.item_search('Seinfeld', {:response_group => 'Medium', :sort => 'salesrank'})
    # @res = res
    # @total_pages = @res.total_pages
    # @first = @res.items.first
    redirect_to :controller => 'welcome', :action => 'index'
  end
  
  # returns the your_picks section
  def your_picks
    puts "your_picks() in WelcomeController"
    #raise TypeError, "PICKS QUEUE: #{$picks_queue.size}, #{$picks_queue.next}"
    
    # Fill up the $your_picks Array with the picks from the PQ
    while (!$picks_queue.empty?)
      if ($your_picks_new.include?($picks_queue.next))
        $picks_queue.pop
      else 
        # ml = MediaLive($picks_queue.next.class)
        $your_picks_new.push($picks_queue.next)
        $your_picks.push($picks_queue.pop)
      end
    end
    
    hide_hidden_picks()
    render_your_picks()
  end
  
   # gets all providers available for this data source
  def get_providers
    puts "get_providers() in WelcomeController"
    type = params[:type]
    descs = $provider_hash[type]
    respond_to do |format|
      format.html { render :partial => "provider_option", :locals => { :descs => descs } }
    end
  end
  
  # changes the current provider (will regenerate tv grid)
  def change_provider
    puts "change_provider() in WelcomeController"
    type = params[:type]
    desc = params[:desc]
    
    $your_picks.clear
    $your_picks_new.clear
    $ds.setProvider( { :type => type, :desc => desc } )
    @stations = $ds.current_provider.stations
    
    cookies.delete(:provider_data)
    provider_cookie = { :provider_id => $ds.current_provider.provider_id, :provider_hash => $ds.selector_hash }
    cookies[:provider_data] = {
      :value => Marshal.dump(provider_cookie),
      :expires => 15.minutes.from_now
    }
    
    respond_to do |format|
      format.html { render :partial => "stations", :locals => { :stations => @stations } }
    end
  end
  
  # rotates the 'your picks' section either forwards or backwards by 6
  def rotate_picks 
    puts "rotate_picks() in WelcomeController"
    
    # May want to return something else so that the JS doesn't do the slideDown()..
    if ($your_picks.size <= 6)
      render_your_picks()
      return
    end
    
    # can rotate forwards or backwards
    if (params[:forward] == "true")
      $picks_forward += 6
      $your_picks.rotate!(6)
      if $picks_forward >= $your_picks.size
        add_more_picks()
        $your_picks.rotate!(-6)
      end
    else
      $picks_forward -= 6
      $your_picks.rotate!(-6)
    end
    
    render_your_picks()
    $hidden_since_rotate = Array.new
    
    
    # TODO: Do I need to recheck for hidden media types here, if more are brought in?
    
    # $index = [0,@your_picks.length-6].max
#     
    # while $index < @your_picks.length do
      # for pick in $hidden_since_rotate do
#         
          # if (@your_picks[$index].class.to_s == pick["media_type"] && @your_picks[$index].id.to_s == pick["media_id"]) 
            # @your_picks.delete_at($index)
            # $index -=1
          # end
      # end
      # $index +=1
    # end
    
    
   
  end
  
  
  # filters the media in the your picks section depending on the check-boxes
  def show_media
    logger.debug 'WelcomeController#show_media'
    $show_movies = false
    $show_tv = false
    $show_netflix = false
    
    $your_picks.delete_if { |p| p.class == MediaNetflix }
    $filtered_picks.delete_if { |p| p.class == MediaNetflix }
    
    if (params[:movie] == "true")
      $show_movies = true
    end
    if (params[:tv_show] == "true")
      $show_tv = true
    end
    if (params[:netflix] == "true")
      $show_netflix = true
    end
    
    
    
    # remove from your picks, put in global filtered array
    $your_picks.delete_if do |p| 
      if ( (p.clazz.to_s == "TvShow" && !($show_tv)) || (p.clazz.to_s == "Movie" && !($show_movies)) ) 
        $filtered_picks.push(p)
        true
      end  
    end
    
    # remove from filtered picks if showing new info
    picks = []
    $filtered_picks.delete_if do |p|
      if ( (p.clazz == TvShow && ($show_tv)) || (p.clazz == Movie && ($show_movies)) )
        picks.push(p)
        true
      end
    end
    
    # add to the filtered PQ
    $your_picks.each { |p| 
      $filtered_queue.push(p, p.media.spudsy_rating)
    }
    picks.each { |p| 
      $filtered_queue.push(p, p.media.spudsy_rating) 
    }
    
    set_netflix_picks()
    $top_netflix_picks.each { |p| 
      n = MediaNetflix.new(p.class, p)
      $filtered_queue.push(n, n.media.spudsy_rating)
    }
    
    # refill the PQ with the your picks filtered, sorted by spudsy rating
    $your_picks = []
    while (!$filtered_queue.empty?)
      $your_picks.push($filtered_queue.pop)
    end
    
    $picks_forward = 0
    render_your_picks()
  end
  
  # hides the media for the user, permanently
  def hide_media
    puts "hide_media() in WelcomeController"
    # TODO: Make sure if it's not movies, it's tv_shows..otherwise give an error
    if params[:media_type] == "movies"
      mType = "Movie"
    else 
      mType = "TvShow"
    end
    
    liked = (params[:like] == "true")? true : false
    
    # add the content to the HiddenUserMedia table
    current_user.hidden_user_medias.push(HiddenUserMedia.new( :user_id => current_user.id, 
                                                              :media_id => params[:media_id], 
                                                              :media_type => mType,
                                                              :liked => liked))
    h = Hash.new
    h["media_id"] = params[:media_id]
    h["media_type"] = mType;                                            
    $hidden_since_rotate.push(h)
    
    index = 0;
    while index < $your_picks.length do
        # puts $your_picks[index].class
        if ( ($your_picks[index].class.to_s == h["media_type"] || $your_picks[index].clazz.to_s == h['media_type']) && $your_picks[index].media.id.to_s == h["media_id"])
          puts $your_picks[index].class.to_s
          puts $your_picks[index].media.id.to_s
          $your_picks.delete_at(index)
          break  # found the hidden variable, break out of loop
        end
   
      index += 1
    end
        
    render_your_picks()
  end
  
  def twitter
    titles = [] 
    $your_picks.each { |media|
	    titles.push media.media.name		
    } 
    searchCriteria = titles[0..5].join(" OR ")
    respond_to do |format|
      format.html { render :partial => "twitter", :locals => { :crit => searchCriteria} }
    end
  end
  
  
  

  
  
  
  
  def render_netflix()
    puts "render_netflix() in WelcomeController"
    set_netflix_picks();
    respond_to do |format|
      format.html { render :partial => "netflix", :locals => { :media => $top_netflix_picks } }
    end
  end
  
  def render_your_picks() 
    puts "render_your_picks() in WelcomeController"
    hide_hidden_picks()
    #raise TypeError, $your_picks
    respond_to do |format|
      format.html { render :partial => "your_picks", :locals => { :media_array => $your_picks} }
    end
  end
  
  private 
    
    
    
    
    
    # Calls bim's service to get tv data; all is in $ds
    def bim(default_provider_id = nil)
      puts "bim() in WelcomeController"
      bim_uuid = "SPUDSYTEST0000000000000001"
      puts "default_provider_id: #{default_provider_id}" 
      $ds = DataService.new(session[:zip_code], bim_uuid, session, default_provider_id)
      $provider_hash = $ds.selector_hash
      @stations = $ds.current_provider.stations
      
      provider_cookie = { :provider_id => $ds.current_provider.provider_id, :provider_hash => $ds.selector_hash }
      cookies[:provider_data] = {
        :value => Marshal.dump(provider_cookie),
        :expires => 5.minutes.from_now
      }
    end
    
    
    
    # Sets up various global variables for the controller
    def set_your_picks
      logger.debug "WelcomeController#set_your_picks"
      $picks_queue = Containers::PriorityQueue.new
      $your_picks = Array.new
      $picks_forward = 0
      $your_picks_new = Array.new
      $show_movies = true
      $show_tv = true
      $filtered_picks = []
      $filtered_queue = Containers::PriorityQueue.new
      $top_netflix_picks = []
      set_netflix_picks()
      $show_netflix = false
    end
    
    
    # sets the netflix picks depending on if we should show tv, movies, or netflix in general
    def set_netflix_picks() 
      logger.debug "WelcomeController#set_netflix_picks"
      $top_netflix_picks = []
      
      if !$show_netflix 
        logger.debug "$show_netflix is false; returning"
        return
      end
      
      # Get netflix media based on what to show/hide
      if ($show_tv && $show_movies) 
        netflixes = NetflixMedia.find(:all, :limit => 30, :order => "spudsy_rating DESC")
      elsif ($show_tv && !$show_movies)
        netflixes = NetflixMedia.where("media_type = 'TvShow'").limit(30).order('spudsy_rating DESC')
      elsif (!$show_tv && $show_movies)
        netflixes = NetflixMedia.where("media_type = 'Movie'").limit(30).order('spudsy_rating DESC')
      elsif (!$show_tv && !$show_movies)
        netflixes = []
      end
      
      # Fill out the top netflix picks array
      netflixes.each { |program| 
        if (program.media_type == "Movie")
          $top_netflix_picks.push(Movie.find(program.media_id))
        else
          $top_netflix_picks.push(TvShow.find(program.media_id))
        end  
      }
        
    end
    
    def test_for_cookies
      logger.debug "WelcomeController#test_for_cookies"

     begin
        location_data = Marshal.load(cookies[:location])
        session[:zip_code] = location_data[:zip_code]
        session[:latitude] = location_data[:latitude]
        session[:longitude] = location_data[:longitude]
     rescue
        puts "Cookies with location data did not exist; calling geolocate."
        geolocate()
     end
      
     begin
       provider_data = Marshal.load(cookies[:provider_data])
       puts "Default provide found: #{provider_data[:provider_id]}."
       bim(provider_data[:provider_id])
     rescue
       puts "No default provider data found. Calling bim()."
       bim()
     end
     
    end
    
    
    
    # Does geolocation to find zip code, latitude and longitude; saved in cookie.
    def geolocate
      puts "geolocate() in WelcomeController"
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
      
      # Store data in cookie, to last 1 day from now (for now)
      location_cookie = { :zip_code => zip_code, :latitude => latitude, :longitude => longitude }
      cookies[:location] = { :value => Marshal.dump(location_cookie), :expires => 1.day.from_now }
    end
    

    
    
    def hide_hidden_picks
      puts "hide_hidden_picks() in WelcomeController"
      if (current_user) 
        hidden_media =  current_user.hidden_user_medias.all
        hidden_ids = Array.new
        
        hidden_media.each do |media|
          hidden_ids.push(media.media_id)
        end
        
        index = 0;
        while index < $your_picks.length
          pick = $your_picks[index].media
          # puts pick
          index_of_pick = hidden_ids.index(pick.id)
          if (!index_of_pick.nil?) 
            if pick.class.to_s == hidden_media[index_of_pick].media_type
              $your_picks.delete_at(index)
              index -=1
            end
          end
          index +=1;
        end
      end
    end
end


class MediaLive
  
  attr_accessor :clazz, :media, :network, :channel, :start_time, :end_time
  
  def initialize(clazz, media, network, channel, start_time, end_time)
    @clazz = clazz
    @media = media
    @network = network
    @channel = channel
    @start_time = start_time
    @end_time = end_time
  end
  
  def ==(another)
    return @clazz == another.clazz && @media == another.media #&& @network == another.network #&& @channel == another.channel && @start_time == another.start_time
  end
  
  def to_s
    "MediaLive: clazz: #{@clazz}, media: #{@media}, network: #{@network}, channel: #{@channel}, time: #{@start_time}-#{@end_time}"
  end
end


class MediaNetflix
  attr_accessor :clazz, :media
  def initialize(clazz, media)
    @clazz = clazz
    @media = media
  end
  
  def ==(another)
    return @clazz = another.clazz && @media == another.media
  end
  
  def to_s
    "MediaNetflix: clazz: #{@clazz}, media: #{@media}"
  end
end

