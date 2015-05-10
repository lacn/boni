class DeferHandler

  ###*
   * State: In progress
   * @type {Number}
  ###
  INPROG = 0
  ###*
   * State: Done
   * @type {Number}
  ###
  DONE = 1
  ###*
   * State: Erorr
   * @type {Number}
  ###
  ERROR = 2

  ###*
   * @param  {Function} callback (optional) Success callback.
  ###
  constructor: (@watch = false) ->
    # Declare `doneListeners` and `failListeners`, add callback to doneListeners
    @doneListeners = []
    @failListeners = []
    @data = undefined
    # Start with in progress state.
    @state = INPROG

  ###*
   * Check if given `obj` is a function.
   * @param {Any} obj   Value to be checked.
   * @return {Boolean}  True if it's function, false otherwise.
  ###
  isFunction = (obj) -> typeof obj is 'function'

  ###*
   * Call all functions in given array..
   * @param {Array<Function>} list Array of functions to be called.
   * @param {Any}             data Data to be passed to called function.
  ###
  callAll = (list, data) -> list.forEach (fn) -> fn data if isFunction fn

  ###*
   * Push a function to given listeners list or call it if current state is expected call state.
   * If `watch` is true, fn is always pushed to list.
   * @param {Function}        fn        Function to be added or called.
   * @param {Array<Function>} list      List where function is added.
   * @param {Number}          callState One of defined `State`s.
   * @param {DeferHandler}    ref       Reference to DeferHandler object.
  ###
  pushOrCall = (fn, list, callState, ref) ->
    (list.push fn; return ref) if ref.watch
    (if ref.state is callState then fn ref.data else if ref.state is INPROG then list.push fn); ref
    # if ref.state is callState
    #   fn ref.data
    # else if ref.state is INPROG
    #   list.push fn
    # this

  ###*
   * Add function to `done` listeners or immediately call it if the state is `DONE` already.
   * @param  {Function} fn  Callback function on `done`.
   * @return {DeferHandler} Reference to `this`.
  ###
  done: (fn) => pushOrCall fn, @doneListeners, DONE, this

  ###*
   * Add function to `fail` listeners or immediately call it if the state is `ERROR` already.
   * @param  {Function} fn  Callback function on `fail`.
   * @return {DeferHandler} Reference to `this`.
  ###
  fail: (fn) => pushOrCall fn, @doneListeners, ERROR, this

  ###*
   * Add function to `done` and `fail` or immediately call it if the state is `DONE` or `ERROR`.
   * @param  {Function} fn  Callback function on `done` or `fail`.
   * @return {DeferHandler} Reference to `this`.
  ###
  always: (fn) => [@done, @fail].forEach (f) -> f fn

  ###*
   * Resolve all pending listeners.
   * @param {Any}     data      Data to be passed to listeners.
   * @param {Boolean} isSuccess True if resolving with success, false otherwise.
  ###
  resolveAll: (data, isSuccess) =>
    @data = data
    # Set state to done if success or ERROR otherwise.
    @state = if isSuccess then DONE else ERROR
    # Use `doneListeners` if success or `failListeners` if not, call functions inside with `data`.
    callAll (if isSuccess then @doneListeners else @failListeners), data

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
   * Get restaurants from server API endpoint.
   * @type {String}
  ###
  RESTAURANTS_URL = '/restaurants'
  ###*
   * Restaurants data object API endpoint.
   * @type {String}
  ###
  VERSION_URL = '/version'

  ###*
   * Polyfill for jQuery's getJSON (not implementing all jQuery functionallity).
   * @param {Strng}   url       URL to make request to.
   * @param {Function} callback (optional) Function to be called on success.
  ###
  getJSON = (url, callback) ->
    deferred = new DeferHandler()
    deferred.done callback
    req = new XMLHttpRequest()
    # Open new XHR async (hence the true) request on `url`.
    req.open 'GET', url, true
    req.onload = ->
      # If request statuc was in range 200 - 400 (success, redirection).
      if req.status >= 200 and req.status < 400
        # Parse `responseText` and resolve all `done` listeners with data.
        data = if req.responseText.trim().length > 0 then JSON.parse req.responseText else undefined
        deferred.resolveAll data, true
      else
        req.onerror()
    req.onerror = ->
      # Resolve all `fail` listeners with `responseText`.
      deferred.resolveAll req.responseText, false
    # Send the request.
    req.send()
    # Return `deferred` handler.
    deferred

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

  getServerRestaurants: (callback) -> getJSON RESTAURANTS_URL, callback

  getServerVersion: (callback) -> getJSON VERSION_URL, callback


class HandlerHelper

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
   * Create deferred geolocation request.
   * @return {DeferHandler} Deferred request for geolocation, resolved when
  ###
  startGeolocationWatch: =>
    # Instantiate DeferHandler with watch option.
    deferred = new DeferHandler true
    if navigator.geolocation?
      # If `geolocation` is available in browser, begin watching for position changes.
      @geolocationWatchID = navigator.geolocation.watchPosition (position) =>
        # Resolve all watchers with array of [lat, lng] (new map position).
        deferred.resolveAll [position.coords.latitude, position.coords.longitude], true
    else
      # The `geolocation` property is not available, resolve with currently stored `center`.
      deferred.resolveAll @center, false
    # Return reference to DeferHandler.
    deferred

  ###*
   * Clear geolocation watcher if it's set.
  ###
  endGeolocationWatch: =>
    if @isWatchingGeolocation()
      navigator.geolocation.clearWatch @geolocationWatchID
      @geolocationWatchID = undefined

  ###*
   * @return True if currently watching for geolocation, false otherwise.
  ###
  isWatchingGeolocation: => @geolocationWatchID?

   * Add server restaurants as map markers.
   * @param {Gmaps handler}   handler   Handler object for maps.
   * @param {Function} callback         Callback function called after markers are added.
  ###
  AddMarkers: (handler, callback) ->
    # Begin get server version request, store request to resolve it later.
    versionRequest = @restaurantStorage.getServerVersion()
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
        getDataReq = @restaurantStorage.getServerRestaurants @restaurantStorage.setRestaurants
      # Add recieved data as map markers.
      getDataReq.done makeMarkers
    # If version is defined (was recieved from server), call loadData(), otherwise
    #   call loadData with `versionRequest`'s response after request completes.
    if @version then loadData() else versionRequest.done loadData

# Bind HandlerHelper class to window so it can be accessed from other files.
window.HandlerHelper = HandlerHelper
