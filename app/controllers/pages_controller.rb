class PagesController < ApplicationController
  def home
  	@restaurants = Restaurant.all
  	@hash = Gmaps4rails.build_markers(@restaurants) do |restaurant, marker|
		  marker.lat restaurant.latitude
		  marker.lng restaurant.longitude
		end
  end
end
