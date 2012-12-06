class SearchController < ApplicationController
  
  def results
    #@movie_results = TvShow.text_search(params[:query]).page(params[:page]).per(5)
    #@tv_results = TvShow.text_search(params[:query])
    @search_results = PgSearch.multisearch(params[:search_box]).page(params[:page]).per(5)

    #@actor_results = Actor.text_search(params[:query])
    
  end
  
end