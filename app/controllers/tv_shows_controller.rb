class TvShowsController < ApplicationController
  respond_to :html, :json
  def show
    puts params[:id]
    @tv_show = TvShow.find(params[:id])
    # return @tv_show
    respond_to do |format|
      format.json { render :json => @tv_show }
    end
  end
end