require "nokogiri"
require "open-uri"

task :scrape => :environment do
	doc = Nokogiri::HTML(open(ENV['source_url']))

	arr = doc.search('restaurantItem name prices', '//h1 | //h2 | //strong').to_a
	arr.delete_at(0) #delete first element: <h1>Imenik lokalov</h1>

	arr.each_slice(4) do |data|
		city = City.where(name: filter_address(data[1].content)[:city])
							 .update_or_create(name: filter_address(data[1].content)[:city])

		Restaurant.where(name: data[0].content)
						 	.update_or_create(name: data[0].content,
						 									 address: filter_address(data[1].content)[:address],
															 city: city,
															 price: filter_price(data[3].content))

		puts data[0].content, filter_address(data[1].content)[:address], city.name, filter_price(data[3].content), "----------------------"
	end
end

def filter_address(data)
	data.delete! '()'
	data = data.split(',')
	{address: data.first, city: data.last.strip.split('/')[0]}	
end

def filter_price(data)
	data.scan(/\d/).join('')
end