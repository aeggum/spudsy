class MoviesController < ApplicationController
  respond_to :html, :json
  def show
    puts params
    @movie = Movie.find(params[:id])
    respond_to do |format|
      #format.json { render :json => @movie }
      format.html { render :partial => "movies/show.html", :locals => { :movie => @movie} }
    end
  end
end
