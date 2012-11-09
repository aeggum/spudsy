class TvShowsController < ApplicationController
  respond_to :html, :json
  def show
    @tv_show = TvShow.find(params[:id])
    respond do |format|
      format.json { render :json => @article }
    end
  end
end