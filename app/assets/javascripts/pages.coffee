# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

###
googlemaps = ->
	console.log(restaurants)
	handler = Gmaps.build('Google')
	handler.buildMap {
	  provider: {}
	  internal: id: 'map'
	}, ->
	  markers = handler.addMarkers(restaurants)
	  handler.bounds.extendWith markers
	  handler.fitMapToBounds()



$(document).ready(googlemaps)
$(document).on('page:load', googlemaps)
###