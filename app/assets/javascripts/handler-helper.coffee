class RestaurantStorage

  ###*
   * Base name of localStorage property.
   * @type {String}
  ###
  OBJECT_NAME: 'restaurants_cache'
  ###*
   * Name of data property.
   * @type {String}
  ###
  DATA_NAME: "#{@OBJECT_NAME}_data"
  ###*
   * Name of version property.
   * @type {String}
  ###
  VERSION_NAME: "#{@OBJECT_NAME}_version"
  ###*
   * Fallback version value, used if localStorage version is not defined.
   * @type {Number}
  ###
  DEFAULT_VERSION: 0

  constructor: ->

  ###*
   * Get restaurants stored in localStorage object.
   * `Restaurant` object sturcture:
   * 	{String} address address of the restaurant
   * 	{String} city    city where the restaurant is located
   * 	{Number} lat     latitude of the restaurant
   * 	{Number} lng     longitude of the restaurant
   * 	{String} name    restaurant name
   * 	{Number} price   price of a student's meal
   *
   * @return {Array<Restaurant>} Array of stored restaurants.
   ###
  getRestaurants: ->
    # Try to parse localStorage data object, return empty array if failed. (implicit return)
    try
      JSON.parse localStorage[@DATA_NAME]
    catch e
      []

  addRestaurants: (restaurantsObj) ->
  ###*
   * Store given restaurants data in localStorage object.
   * @param {Array<Restaurant>} restaurantsObj Array of restaurats.
  ###
    # Using try in case of JSON.stringify error.
    try
      ###*
       * Escape given string to be compatible with JSON.parse.
       * @param  {String} string String to be escaped
       * @return {String}        Escaped string
      ###
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

  ###*
   * Get version stored in localStorage object.
   *
   * @return {Number} Version stored in localStorage (should be in form of timestamp).
  ###
  getVersion: => JSON.parse localStorage[@VERSION_NAME] or @DEFAULT_VERSION

  ###*
   * Set/update version number stored in localStorage object.
   * @param {Number} version New version number to be stored.
  ###
  setVersion: (version = @DEFAULT_VERSION) => localStorage[@VERSION_NAME] = version

  isUpToDate: (dataTimestamp) => @getVersion is dataTimestamp
  ###*
   * Check if given version timestamp is up to date with stored data.
   * @param {Number} serverTimestamp Timestamp from server.
  ###


class HandlerHelper

  ###*
   * Get restaurants from server API endpoint.
   * @type {String}
  ###
  RESTAURANTS_URL: '/restaurants'
  ###*
   * Restaurants data object API endpoint.
   * @type {String}
  ###
  VESION_URL: '/version'

  ###*
   * Default constructor, set property center (implicit this.center = center),
   * 	instantiate `RestaurantStorage` and start server version request (async).
   * @param  {Array<Number>} @center Array [lat, lng] of currently centered location.
  ###
  constructor: (@center) ->
    @restaurantStorage = new RestaurantStorage()
    @version = 0
    @versionRequest = $.getJSON @VESION_URL, (data) -> @version = data.version

  getCenter: => @center
  setCenter: (@center) =>

  ###*
   * Add server restaurants as map markers.
   * @param {Gmaps handler}   handler   Handler object for maps.
   * @param {Function} callback         Callback function called after markers are added.
  ###
  AddMarkers: (handler, callback) ->
    ###*
     * Make maps marker infowindow.
     * @param {Restaurant} obj Restaurant object (described at `RestaurantStorage.getRestaurants`).
     * @return {Object} Object with restaurant geolocation and infowindow HTML.
    ###
    makeInfowindow = (obj) ->
      lat: obj.lat
      lng: obj.lng
      infowindow: """
      <p><b>#{obj.name}</b></p>
      <p>#{obj.address}, #{obj.city}</p>
      <p>cena doplačila: #{obj.price} &#8364;</p>"""

    makeMarkers = (data) ->
      markers = handler.addMarkers data.map makeInfowindow
    ###*
     * Turn `restaurants` into infowindows and add them to map as markers.
     * @param {Array<Restaurant>} restaurants Array of restaurants from localStorage or server.
    ###
      # Call makeInfowindow for each `Restaurant` in `restaurants`, returns an array of
      #   infowindows which are added to map as markers.
      # Extend map bounds with markers - make all markers fit to map.
      handler.bounds.extendWith markers
      # Call `callback` if it was given.
      callback() if callback

    loadData = (data) =>
      @version = data.version if data
    ###*
     * Load restaurants data from localStorage or server.
     * @param {Array<Restaurant>} versionData (optional) Data from `versionRequest` response.
    ###
      # If called as .done callback (`versionData` was recieved), update `this.version` property.
      if not @restaurantStorage.isUpToDate @version
        console.log 'load from server'
        # If local data is not up to date with server data, get data from server.
        $.getJSON @RESTAURANTS_URL, (data) =>
          @restaurantStorage.addRestaurants data
          # Update locally stored data.
          # Add data as map markers.
          makeMarkers data
      else
        console.log 'load from cache'
        # Get local data and add it as map markers.
        makeMarkers @restaurantStorage.getRestaurants()
    # If version is defined (was recieved from server), call loadData(), otherwise
    #   call loadData with `versionRequest`'s response after request completes.
    if @version then loadData() else @versionRequest.done loadData

# Bind HandlerHelper class to window so it can be accessed from other files.
window.HandlerHelper = HandlerHelper
