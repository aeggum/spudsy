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
  before_filter :test_for_cookies, :only => :index
  # before_filter :geolocate, :only => :index
  # caches_action :index, :expires_in => 2.minutes
  # before_filter :bim, :only => :index
  
  
  def index
    logger.debug "---START--- WelcomeController#index ---------------------------------"
    $hidden_since_rotate = Array.new;
    #raise TypeError, $ds
    logger.debug "---END----- WelcomeController#index ---------------------------------"
  end
  
  def details
    logger.debug "---START--- WelcomeController#details--------------------------------"
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
    logger.debug "---END----- WelcomeController#details -------------------------------"
  end
  
  # Change the zip code, update the table, add zip code to user's zip code location
  def update_zip #zip_code
    logger.debug "---START--- WelcomeController#update_table -------------------------"
    logger.debug "Params: #{params}"
    
    zip_code = params[:zip_code]
    # Store data in cookie, to last 1 day from now (for now)
    location_cookie = { :zip_code => zip_code, :latitude => nil, :longitude => nil }
    cookies[:location] = { :value => Marshal.dump(location_cookie), :expires => 1.day.from_now }
    
    puts "No default provider data found. Calling bim()."
    bim( { :zip_code => zip_code } )
    
    $your_picks.clear
    $your_picks_new.clear
    #$ds.setProvider( { :type => type, :desc => desc } )
    @stations = $ds.current_provider.stations
    
    cookies.delete(:provider_data)
    # provider_cookie = { :provider_id => $ds.current_provider.provider_id, :provider_hash => $ds.selector_hash }
    # cookies[:provider_data] = {
      # :value => Marshal.dump(provider_cookie),
      # :expires => 15.minutes.from_now
    # }
    
    respond_to do |format|
      format.html { render :partial => "stations", :locals => { :stations => @stations } }
    end
    
    #TODO: Here would be a good spot to get the best picks before sending it to the view
    # because if we have netflix picks showing up, they get lost after this call
    
    #TODO: Should clean this up and add the new zip code to the user's database
            # -- Also should save the user's default provider
    
    logger.debug "---END--- WelcomeController#update_table ---------------------------"
  end
  
  
  
  
  
  
  # returns the your_picks section
  def your_picks
    logger.debug "---START--- WelcomeController#your_picks ----------------------------"
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
    
    #hide_hidden_picks()
    render_your_picks()
    logger.debug "---END----- WelcomeController#your_picks ----------------------------"
  end
  
   # gets all providers available for this data source
  def get_providers
    logger.debug "---START--- WelcomeController#get_providers -------------------------"
    type = params[:type]
    descs = $provider_hash[type]
    respond_to do |format|
      format.html { render :partial => "provider_option", :locals => { :descs => descs } }
    end
    logger.debug "---END----- WelcomeController#get_providers -------------------------"
  end
  
  # changes the current provider (will regenerate tv grid)
  def change_provider
    logger.debug "---START--- WelcomeController#change_provider -----------------------"
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
    logger.debug "---END----- WelcomeController#change_provider -----------------------"
  end
  
  
  
  
  # rotates the 'your picks' section either forwards or backwards by 6
  def rotate_picks 
    logger.debug "---START--- WelcomeController#rotate_picks --------------------------"
    options = Hash.new
    options[:forward] = params[:forward] == "true"

    if (params[:your_picks] == "true")
      options[:your_picks] = true
      rotate(options)
    elsif (params[:netflix] == "true")
      options[:netflix] = true
      rotate(options)
    end   
    logger.debug "---END----- WelcomeController#rotate_picks --------------------------"
  end
    
    
    
    

  
  
  # filters the media in the your picks section depending on the check-boxes
  def show_media
    logger.debug "---START--- WelcomeController#show_media ----------------------------"
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
    
    $netflix_forward = 0
    $picks_forward = 0
    render_your_picks()
    
    logger.debug "---END----- WelcomeController#show_media ----------------------------"
  end
  
  # hides the media for the user, permanently
  def hide_media
    logger.debug "---START--- WelcomeController#hide_media ----------------------------"
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
          # puts $your_picks[index].class.to_s
          # puts $your_picks[index].media.id.to_s
          $your_picks.delete_at(index)
          break  # found the hidden variable, break out of loop
        end
   
      index += 1
    end
        
    render_your_picks()
    logger.debug "---END----- WelcomeController#hide_media ----------------------------"
  end
  
  def twitter
    logger.debug "---START--- WelcomeController#twitter -------------------------------"
    titles = [] 
    $your_picks.each { |media_source|
	    titles.push media_source.media.name		
    } 
    searchCriteria = titles[0..5].join(" OR ")
    respond_to do |format|
      format.html { render :partial => "twitter", :locals => { :crit => searchCriteria} }
    end
    logger.debug "---END----- WelcomeController#twitter -------------------------------"
  end
  
  
  

  
  
  
  
  def render_netflix()
    logger.debug "---START--- WelcomeController#render_netflix ------------------------"
    
    #set_netflix_picks();
    respond_to do |format|
      format.html { render :partial => "netflix", :locals => { :media => $top_netflix_picks } }
    end
    
    logger.debug "---END----- WelcomeController#render_netflix ------------------------"
  end
  
  def render_your_picks() 
    logger.debug "---START--- WelcomeController#render_your_picks ---------------------"

    hide_hidden_picks()
    #raise TypeError, $your_picks
    respond_to do |format|
      format.html { render :partial => "your_picks", :locals => { :media_array => $your_picks} }
    end
    
    logger.debug "---END----- WelcomeController#render_your_picks ---------------------"
  end
  
  private 
    
    
    
    
    
    # Calls bim's service to get tv data; all is in $ds
    def bim(options) #default_provider_id = nil)
      logger.debug "---START--- WelcomeController#bim() -------------------------------"
      logger.debug "Options: #{options}"
      
      default_provider_id = options[:default_provider_id]
      zip_code = options[:zip_code]
      bim_uuid = "SPUDSYTEST0000000000000001"
      puts "default_provider_id: #{default_provider_id}" 
      $ds = DataService.new(zip_code, bim_uuid, session, default_provider_id)
      $provider_hash = $ds.selector_hash
      @stations = $ds.current_provider.stations
      
      provider_cookie = { :provider_id => $ds.current_provider.provider_id, :provider_hash => $ds.selector_hash }
      cookies[:provider_data] = {
        :value => Marshal.dump(provider_cookie),
        :expires => 5.minutes.from_now
      }
      
      logger.debug "---END----- WelcomeController#bim() -------------------------------"
    end
    
    
    
    # Sets up various global variables for the controller
    def set_your_picks
      logger.debug "---START--- WelcomeController#set_your_picks ----------------------"
      $picks_queue = Containers::PriorityQueue.new
      $your_picks = Array.new
      $picks_forward = 0
      $netflix_forward = 0
      $netflix_forward_factor = 1
      $your_picks_new = Array.new
      $filtered_picks = []
      $filtered_queue = Containers::PriorityQueue.new
      $top_netflix_picks = []
      set_netflix_picks()
      $show_netflix = false
      $show_movies = true
      $show_tv = true
      logger.debug "---END----- WelcomeController#set_your_picks ----------------------"
    end
    
    
    # sets the netflix picks depending on if we should show tv, movies, or netflix in general
    def set_netflix_picks() 
      logger.debug "---START--- WelcomeController#set_netflix_picks -------------------"
      offset_size = 25
      $top_netflix_picks = []
      
      if !$show_netflix 
        logger.debug "$show_netflix is false; returning"
        return
      end
      
      # Get netflix media based on what to show/hide
      if ($show_tv && $show_movies) 
        netflixes = NetflixMedia.find(:all, :limit => offset_size, :order => "spudsy_rating DESC")
      elsif ($show_tv && !$show_movies)
        netflixes = NetflixMedia.where("media_type = 'TvShow'").limit(offset_size).order('spudsy_rating DESC')
      elsif (!$show_tv && $show_movies)
        netflixes = NetflixMedia.where("media_type = 'Movie'").limit(offset_size).order('spudsy_rating DESC')
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
       
      logger.debug "---END----- WelcomeController#set_netflix_picks -------------------" 
    end
    
    # options is a hash with the type of media (netflix, hulu, amazon, etc) 
    # to get more media for
    def add_more(options)
      logger.debug "---START--- WelcomeController#add_more ----------------------------"
      
      
      if (options[:netflix] == true)
        limit = 25
        offset_size = limit * options[:netflix_factor]
        puts offset_size
        more = []
        if ($show_tv && $show_movies)
          more = NetflixMedia.find(:all, :offset => offset_size, :limit => limit, :order => "spudsy_rating DESC")
        elsif ($show_tv && !$show_movies)
          more = NetflixMedia.where("media_type = 'TvShow'").offset(offset_size).limit(limit).order("spudsy_rating DESC") 
        elsif (!$show_tv && $show_movies)
          more = NetflixMedia.where("media_type = 'Movie'").offset(offset_size).limit(limit).order('spudsy_rating DESC')
        end
        
        more.each { |program| 
          if (program.media_type == "Movie")
            $top_netflix_picks.push(Movie.find(program.media_id))
          else 
            $top_netflix_picks.push(TvShow.find(program.media_id))
          end
        }
        
        return more.size
      end
      
      logger.debug "---END----- WelcomeController#add_more ----------------------------"
    end
    
    def test_for_cookies
      logger.debug "---START--- WelcomeController#test_for_cookies --------------------"

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
        bim( { :zip_code => session[:zip_code], :default_provider_id => provider_data[:provider_id] } )
      rescue
        puts "No default provider data found. Calling bim()."
        bim( { :zip_code => session[:zip_code] } )
      end
     
      logger.debug "---END----- WelcomeController#test_for_cookies --------------------"
    end
    
    
    
    # Does geolocation to find zip code, latitude and longitude; saved in cookie.
    def geolocate
      logger.debug "---START--- WelcomeController#geolocate ---------------------------"
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
      logger.debug "---END----- WelcomeController#geolocate ---------------------------"
    end
    
    
    
    
    
    # hides the hidden picks for a signed-in user
    def hide_hidden_picks
      logger.debug "---START--- WelcomeController#hide_hidden_picks -------------------"
      
      if (current_user) 
        hidden_media =  current_user.hidden_user_medias.all
        
        # delete if you find a match in the user's hidden media array
        $your_picks.delete_if { |media| 
          pick = media.media
          found = hidden_media.select { |v| v.media_id == pick.id && v.media_type == pick.class.to_s }
          if (!found.empty?)
            true
          end
        }
        
        # delete if you find a match in the user's hidden media array
        $top_netflix_picks.delete_if { |media| 
          if ( !(hidden_media.select { |v| v.media_id == media.id && v.media_type == media.class.to_s }.empty?) )
            true
          end
        }
        
      end
      
      logger.debug "---END----- WelcomeController#hide_hidden_picks -------------------"
    end
    
      # Rotates {currently} either the your_picks or netflix sections forwards or backwards
    def rotate(option)
      logger.debug "---START--- WelcomeController#rotate ------------------------------"
      
      if (option[:your_picks]) 
        # May want to return something else so that the JS doesn't do the slideDown()..
        if ($your_picks.size <= 6)
          render_your_picks()
          return
        end
        
        # Rotates your picks forwards or backwards
        if (option[:forward])
          $picks_forward += 6
          $your_picks.rotate!(6)
          if $picks_forward >= $your_picks.size
            $your_picks.rotate!(-6)
          end
        else
          $picks_forward -= 6
          $your_picks.rotate!(-6)
        end
        
        render_your_picks()
        $hidden_since_rotate = []
      
      # Netflix rotations.. a bit more complex, attempt to keep order
      elsif (option[:netflix])
        if (option[:forward])
          $netflix_forward += 6
          $top_netflix_picks.rotate!(6)
          
          # keep things in order; request more picks if nearing end of array
          if ($netflix_forward + 6 >= $top_netflix_picks.size)
            diff = ($netflix_forward + 6) - $top_netflix_picks.size
            $top_netflix_picks.rotate!(diff)
            $netflix_forward += diff
           
            # puts "netflix_forward_factor: #{$netflix_forward_factor}"
            num_added = add_more( {:netflix => true, :netflix_factor => $netflix_forward_factor} )
            $netflix_forward_factor += 1
            $top_netflix_picks.rotate!(-num_added)
          end
        else 
          diff = ($netflix_forward >= 6? 6 : $netflix_forward)
          $netflix_forward -= diff
          $top_netflix_picks.rotate!(-diff)
        end
        
        # puts "netflix forward: #{$netflix_forward}"
        # puts "top netflix picks size: #{$top_netflix_picks.size}"
        render_netflix()
      end
      
      
      logger.debug "---END--- WelcomeController#rotate --------------------------------"
    end
    
end







