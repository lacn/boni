json.array! @restaurants do |restaurant|
  json.name restaurant.name
  json.address restaurant.address
  json.city restaurant.city.name
  json.price restaurant.price_in_eur
  json.lat restaurant.latitude
  json.lng restaurant.longitude
end
