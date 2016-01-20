require 'nokogiri'
require 'open-uri'

line = '----------------------'

task scrape: :environment do
  doc = Nokogiri::HTML(open(ENV['source_url']))
  arr = doc.search('restaurantItem name prices', '//h1 | //h2 | //strong').to_a

  # Skip first element: <h1>Imenik lokalov</h1>.
  added_restaurants = arr.drop(1).each_slice(4).map.with_index do |data, i|
    # data: [0] => "restaurant name", [1] => "(address, city)", [2] => "x,xx EUR", [4] => "x,xx EUR"
    data_content = data.map(&:content)
    address = filter_address(data_content[1])

    city = City.where(name: address[:city]).update_or_create(name: address[:city])
    restaurant = Restaurant.where(name: data_content[0]).update_or_create(restaurant_params(data_content, address, city))
    log(restaurant, i)
    sleep 1

    restaurant
  end

  puts line, 'Not found:', line

  (Restaurant.all - added_restaurants).each.with_index do |restaurant, i|
    log(restaurant, i)
    restaurant.destroy
  end
end

private

def filter_full_address(data)
  # Address is in format "(address, city)", so remove surrounding `()`.
  data.delete!('()')
end

def filter_address(data)
  [:address, :city].zip(filter_full_address(data).split(',').map { |s| s.strip.split('/').first }).to_h
end

def filter_price(data)
  # TODO: refactor DB to use decimal, then use `data.sub(',', '.').to_f`.
  data.scan(/\d/).join('')
end

def restaurant_params(data_content, address, city)
  {
    name: data_content[0],
    address: address[:address],
    full_address: filter_full_address(data_content[1]),
    city: city,
    price: filter_price(data_content[2])
  }
end

def log(restaurant, i)
  puts "#{i + 1}.", restaurant.name, restaurant.address, restaurant.city.name, restaurant.price, line
end
