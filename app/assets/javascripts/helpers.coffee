class RestaurantStorage

  ###*
   * Base name of localStorage property.
   * @type {String}
  ###
  OBJECT_BASE_NAME = 'restaurants_cache'
  ###*
   * Name of data property.
   * @type {String}
  ###
  DATA_NAME = "#{OBJECT_BASE_NAME}_data"
  ###*
   * Name of version property.
   * @type {String}
  ###
  VERSION_NAME = "#{OBJECT_BASE_NAME}_version"
  ###*
   * Fallback version value, used if localStorage version is not defined.
   * @type {Number}
  ###
  DEFAULT_VERSION = 0

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
      JSON.parse localStorage[DATA_NAME]
    catch e
      []

  ###*
   * Store given restaurants data in localStorage object.
   * @param {Array<Restaurant>} restaurantsObj Array of restaurats.
  ###
  setRestaurants: (restaurantsObj) ->
    # Using try in case of JSON.stringify error.
    try
      ###*
       * Escape given string to be compatible with JSON.parse.
       * @param  {String} string String to be escaped
       * @return {String}        Escaped string
      ###
      escape = (string) ->
        string
          .replace /\\n/g, "\\n"
          .replace /\\'/g, "\\'"
          .replace /\\"/g, '\\"'
          .replace /\\&/g, "\\&"
          .replace /\\r/g, "\\r"
          .replace /\\t/g, "\\t"
          .replace /\\b/g, "\\b"
          .replace /\\f/g, "\\f"
      # Use timeout to make adding (takes ~3s) async.
      setTimeout (-> localStorage[DATA_NAME] = escape JSON.stringify restaurantsObj), 1

  ###*
   * Get version stored in localStorage object.
   *
   * @return {Number} Version stored in localStorage (should be in form of timestamp).
  ###
  getVersion: -> JSON.parse localStorage[VERSION_NAME] or DEFAULT_VERSION

  ###*
   * Set/update version number stored in localStorage object.
   * @param {Number} version New version number to be stored.
  ###
  setVersion: (version = DEFAULT_VERSION) -> localStorage[VERSION_NAME] = version

  ###*
   * Check if given version timestamp is up to date with stored data.
   * @param {Number} serverTimestamp Timestamp from server.
  ###
  isUpToDate: (serverTimestamp) => @getVersion is serverTimestamp


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
   * Set property center (implicit this.center = center), instantiate `RestaurantStorage`.
   * @param  {Array<Number>} @center Array [lat, lng] of currently centered location.
  ###
  constructor: (@center) ->
    @restaurantStorage = new RestaurantStorage()
    @version = 0

  getCenter: => @center
  setCenter: (@center) =>

  ###*
   * Add server restaurants as map markers.
   * @param {Gmaps handler}   handler   Handler object for maps.
   * @param {Function} callback         Callback function called after markers are added.
  ###
  AddMarkers: (handler, callback) ->
    # Begin get server version request, store request to resolve it later.
    versionRequest = $.getJSON @VESION_URL, (data) => @version = data.version
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

    ###*
     * Turn `restaurants` into infowindows and add them to map as markers.
     * @param {Array<Restaurant>} restaurants Array of restaurants from localStorage or server.
    ###
    makeMarkers = (restaurants) ->
      # Call makeInfowindow for each `Restaurant` in `restaurants`, returns an array of
      #   infowindows which are added to map as markers.
      markers = handler.addMarkers restaurants.map makeInfowindow
      # Extend map bounds with markers - make all markers fit to map.
      handler.bounds.extendWith markers
      # Call `callback` if it was given.
      callback() if callback

    ###*
     * Load restaurants data from localStorage or server.
     * @param {Array<Restaurant>} versionData (optional) Data from `versionRequest` response.
    ###
    loadData = (versionData) =>
      # If called as .done callback (`versionData` was recieved), update `this.version` property.
      @version = versionData.version if versionData
      if @restaurantStorage.isUpToDate @version
        # Get local data and add it as map markers, make it accessible by .done function
        # to simulate getJSON request deferred resolve.
        getDataReq = done: @restaurantStorage.getRestaurants
      else
        # If local data is not up to date with server data, get data from server.
        # Use `RestaurantStorage.setRestaurants` to update locally stored data.
        # Store request to resolve it later.
        getDataReq = $.getJSON @RESTAURANTS_URL, @restaurantStorage.setRestaurants
      # Add recieved data as map markers.
      getDataReq.done makeMarkers
    # If version is defined (was recieved from server), call loadData(), otherwise
    #   call loadData with `versionRequest`'s response after request completes.
    if @version then loadData() else versionRequest.done loadData

# Bind HandlerHelper class to window so it can be accessed from other files.
window.HandlerHelper = HandlerHelper
