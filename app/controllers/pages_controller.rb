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

  def restaurants
    @restaurants = Restaurant.all
    @hash = Gmaps4rails.build_markers(@restaurants) do |restaurant, marker|
      marker.lat  restaurant.latitude
      marker.lng  restaurant.longitude
      marker.json({name: restaurant.name, address: restaurant.address, city: restaurant.city.name, price: restaurant.price_in_eur })
      # marker.infowindow render_to_string(:partial => "/pages/infowindow",
      #                                    :locals => { :restaurant => restaurant})
    end
    respond_to do |format|
      format.json { render json: @hash }
    end
  end
end
