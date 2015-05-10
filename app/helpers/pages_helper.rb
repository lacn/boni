module PagesHelper
  def latitude
    Geocoder.search(user_ip.to_s).first.latitude || 46.05
  end

  def longitude
    Geocoder.search(user_ip.to_s).first.longitude || 14.5
  end

  def user_ip
    request.env["HTTP_X_FORWARDED_FOR"].try(:split, ',').try(:first) || request.env["REMOTE_ADDR"]
  end
end
