class Restaurant < ActiveRecord::Base
	belongs_to :city
	include UpdateOrCreate

end
