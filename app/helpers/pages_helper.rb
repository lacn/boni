module PagesHelper
  def latitude
    latitude = Geocoder.search(user_ip.to_s).first.latitude
    latitude = 46.0500 if latitude == 0.0
    logger.info user_ip
    logger.info latitude
  end

  def longitude
    longitude = Geocoder.search(user_ip.to_s).first.longitude
    longitude = 14.5000 if longitude == 0.0
    logger.info longitude
  end

  def user_ip
    request.env["HTTP_X_FORWARDED_FOR"].try(:split, ',').try(:first) || request.env["REMOTE_ADDR"]
  end

  def user_ip
    request.env["HTTP_X_FORWARDED_FOR"].try(:split, ',').try(:first) || request.env["REMOTE_ADDR"]
  end
end
