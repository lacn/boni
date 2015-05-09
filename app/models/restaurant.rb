class Restaurant < ActiveRecord::Base
	belongs_to :city
	include UpdateOrCreate

	attr_accessor :full_address
	geocoded_by :full_address
	before_save :geocode, if: ->(obj){ obj.address.present? and obj.address_changed? }

	def price_in_eur
		self.price/100.00 unless price.nil?
	end
end
