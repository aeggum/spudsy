module ApplicationHelper
  #return a title on a per-page basis
  def full_title
    base_title = "Spudsy";
    if @title.nil?
      base_title
    else
      "#{@title} | #{base_title} "
    end
  end
end
