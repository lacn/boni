class PagesController < ApplicationController
  def home
  	@restaurants = Restaurant.all
  	@hash = Gmaps4rails.build_markers(@restaurants) do |restaurant, marker|
		  marker.lat  restaurant.latitude
		  marker.lng  restaurant.longitude
      marker.infowindow render_to_string(:partial => "/pages/infowindow",
                                         :locals => { :restaurant => restaurant})
		end
  end
end
