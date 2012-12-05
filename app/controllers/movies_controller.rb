class MoviesController < ApplicationController
  respond_to :html, :json
  def show
    @movie = Movie.find(params[:id])
    respond_to do |format|
      #format.json { render :json => @movie }
      format.html { render :partial => "movies/overlay.html", :locals => { :movie => @movie} }
    end
  end
end
