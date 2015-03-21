class City < ActiveRecord::Base
	has_many :restaurants
	include UpdateOrCreate
end
