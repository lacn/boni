module PagesHelper
  def latitude
<<<<<<< HEAD
    latitude = get_address["latitude"]
=======
    latitude = Geocoder.search(user_ip.to_s).first.latitude.to_f
>>>>>>> origin/master
    latitude = 46.05 if latitude == 0.0
  end

  def longitude
<<<<<<< HEAD
    longitude = get_address["longitude"]
    longitude = 14.5 if longitude == 0.0
  end

  def user_ip
    request.env["HTTP_X_FORWARDED_FOR"].try(:split, ',').try(:first) || request.env["REMOTE_ADDR"]
=======
    longitude = Geocoder.search(user_ip.to_s).first.longitude.to_f
    longitude = 14.5 if longitude == 0.0
>>>>>>> origin/master
  end

  def get_address
    HTTParty.get('http://freegeoip.net/json/'+user_ip)
  end
end
