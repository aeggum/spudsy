class SearchController < ApplicationController
  
  def results
    #@movie_results = Movie.text_search(params[:query]) 
    #@tv_results = TvShow.text_search(params[:query])
    @search_results = PgSearch.multisearch(params[:query])
    #@actor_results = Actor.text_search(params[:query])
    
  end
  
end