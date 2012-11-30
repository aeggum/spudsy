class TvShowsController < ApplicationController
  respond_to :html, :json
  def show
    puts params[:id]
    @tv_show = TvShow.find(params[:id])
    respond_to do |format|
      #format.json { render :json => @movie }
      format.html { render :partial => "tv_shows/overlay.html", :locals => { :tv_show => @tv_show} }
    end
  end
end