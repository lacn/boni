class PagesController < ApplicationController
  def home
    @map_props = {
      restaurants: [],
      zoom: 9,
      center: {
        lat: 46.12,
        lng: 14.82
      }
    }
  end

  def restaurants
    @restaurants = Restaurant.all.includes(:city)
  end

  def version
    respond_to do |format|
      format.json { render json: Version.first }
    end
  end
end
