class RestaurantStorage

  # Base name of localStorage property.
  OBJECT_NAME: 'restaurants_cache'
  # Name of data property.
  DATA_NAME: "#{@OBJECT_NAME}_data"
  # Name of version property.
  VERSION_NAME: "#{@OBJECT_NAME}_version"
  # Fallback version value, used if localStorage version is not defined.
  DEFAULT_VERSION: 0

  constructor: ->

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

  getVersion: => JSON.parse localStorage[@VERSION_NAME] or @DEFAULT_VERSION

  setVersion: (version = @DEFAULT_VERSION) => localStorage[@VERSION_NAME] = version

  isUpToDate: (dataTimestamp) => @getVersion is dataTimestamp


class HandlerHelper

  RESTAURANTS_URL: '/restaurants'
  VESION_URL: '/version'

  constructor: (@center) ->
    @restaurantStorage = new RestaurantStorage()
    @version = 0
    @versionRequest = $.getJSON @VESION_URL, (data) -> @version = data.version

  getCenter: => @center
  setCenter: (@center) =>

  AddMarkers: (handler, callback) ->
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
      callback() if callback

    loadData = (data) =>
      @version = data.version if data
      if not @restaurantStorage.isUpToDate @version
        console.log 'load from server'
        $.getJSON @RESTAURANTS_URL, (data) =>
          @restaurantStorage.addRestaurants data
          makeMarkers data
      else
        console.log 'load from cache'
        makeMarkers @restaurantStorage.getRestaurants()

    if @version then loadData() else @versionRequest.done loadData

window.HandlerHelper = HandlerHelper
