class RestaurantStorage

  OBJECT_NAME: 'restaurants_cache'

  constructor: ->
    @DATA_NAME = "#{@OBJECT_NAME}_data"
    @VERSION_NAME = "#{@OBJECT_NAME}_version"

  getRestaurants: ->
    try
      JSON.parse localStorage[@DATA_NAME]
    catch e
      []

  addRestaurants: (restaurantsObj) ->
    try
      escape = (string) ->
        string.replace(/\\n/g, "\\n")
          .replace(/\\'/g, "\\'")
          .replace(/\\"/g, '\\"')
          .replace(/\\&/g, "\\&")
          .replace(/\\r/g, "\\r")
          .replace(/\\t/g, "\\t")
          .replace(/\\b/g, "\\b")
          .replace(/\\f/g, "\\f")
      setTimeout =>
        localStorage[@DATA_NAME] = escape JSON.stringify restaurantsObj
      , 1
      true
    catch e
      false

  isUpToDate: (timestamp) ->
    !!localStorage[@DATA_NAME]


class HandlerHelper

  RESTAURANTS_URL: '/restaurants'

  constructor: (@center) ->
    @restaurantStorage = new RestaurantStorage()
    window.test = @restaurantStorage

  getCenter: => @center
  setCenter: (@center) =>

  AddMarkers: (handler) ->
    makeInfowindow = (obj) ->
      lat: obj.lat
      lng: obj.lng
      infowindow: """
      <p><b>#{obj.name}</b></p>
      <p>#{obj.address}, #{obj.city}</p>
      <p>cena doplačila: #{obj.price} &#8364;</p>"""

    makeMarkers = (data) ->
      markers = handler.addMarkers data.map makeInfowindow
      handler.bounds.extendWith markers
      # Fit map to bounds of markers, meaning it will
      # zoom in to just fit all the markers added.
      handler.fitMapToBounds()

    if not @restaurantStorage.isUpToDate Date.now()
      console.log 'load from server'
      $.getJSON @RESTAURANTS_URL, (data) =>
        @restaurantStorage.addRestaurants data
        makeMarkers data
    else
      console.log 'load from cache'
      makeMarkers @restaurantStorage.getRestaurants()

window.HandlerHelper = HandlerHelper
