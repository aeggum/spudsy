require "rotten"
class WelcomeController < ApplicationController
  Rotten.api_key = 'pykjuv5y44fywgpu2m7rt4dk'
  
  def index
   
    # Doing some testing with the RT API wrapper
    argo = Rotten::Movie.find_first "Argo"
    @argo_score = argo.ratings['critics_score']
    
    perks = Rotten::Movie.find_first "Perks of being a wallflower"
    @perks_score = perks.ratings['critics_score']
    @perks_poster = perks.posters['detailed']
    
  end
  
  def details
    # This is a placeholder - users will be redirected to it when they are signed in, for now
  end
end
