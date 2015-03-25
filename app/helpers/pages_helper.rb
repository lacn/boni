module PagesHelper
  def latitude(latitude)
    latitude = 46.0500 if latitude == 0.0
  end

  def longitude(longitude)
    longitude = 14.5000 if longitude == 0.0
  end
end
