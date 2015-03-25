module PagesHelper
  def latitude
    latitude = get_address["latitude"]
    latitude = 46.05 if latitude == 0.0
  end

  def longitude
    longitude = get_address["longitude"]
    longitude = 14.5 if longitude == 0.0
  end

  def user_ip
    request.env["HTTP_X_FORWARDED_FOR"].try(:split, ',').try(:first) || request.env["REMOTE_ADDR"]
  end

  def get_address
    HTTParty.get('http://freegeoip.net/json/'+user_ip)
  end
end
