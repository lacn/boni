
###*
 * Level of map zoom on page load.
 * @type {Number}
###
ZOOM_LEVEL = 18

buildMap = (center) ->
  ###*
   * Get `#follow-location` DOM element.
   * @type {Element}
  ###
  watchIconEl = document.getElementById 'follow-location'
  loaderIconEl = document.getElementById 'location-loading'
  ###*
   * Instantiate HandlerHelper with given `center`.
   * @type {HandlerHelper}
  ###
  Helper = new HandlerHelper center, watchIconEl
  ###*
   * Centers the map of passed handler.
   * Using Helper object to get center (initialized from rails).
   * @param {GoogleMapsHandler} handler Handler of Google Maps object.
  ###
  centerMap = (handler, center = Helper.getCenter()) ->
    handler.map.centerOn center
  ###*
   * Update center location stored in Helper object.
   * @param {GoogleMapsHandler} handler Handler of Google Maps object.
  ###
  updateCenter = (handler) ->
    Helper.setCenter handler.map.getServiceObject().getCenter()
  ###*
   * Instantiate a Google maps handler.
   * @type {Gmaps handler}
  ###
  handler = Gmaps.build 'Google', true, false
  # Build a map inside `#map` element.
  handler.buildMap
    internal:
      # Build map in DOM element with id `map`.
      id: 'map'
    # Callback function (called when map is initialized).
    ->
      # Save functions to start and end watching for geolocation changes.
      # Watch starts at the beginning and ends when map is first dragged
      #   or when user presses the `#follow-location` button.
      startGeolocationWatch = ->
        # Show loader icon.
        HandlerHelper.addClass loaderIconEl, 'active'
        # Start with first call state.
        firstCall = true
        # Get getGeolocation using browser API.
        Helper.startGeolocationWatch().done (newCenter) ->
          # Center map on just updated `newCenter`.
          centerMap handler, newCenter
          # Store `newCenter`, which is currently map center.
          updateCenter handler
          # Location loading done, hide loader icon.
          HandlerHelper.removeClass loaderIconEl, 'active'
          # If this is first call, zoom the map and set fist call state to false.
          if firstCall
            # Zoom map to initial zoom level.
            handler.getMap().setZoom ZOOM_LEVEL
            firstCall = false
      endGeolocationWatch = ->
        # Show loader icon.
        HandlerHelper.addClass loaderIconEl, 'active'
        # Call helper method to end watching for geolocation changes.
        Helper.endGeolocationWatch()
        # Location watch disabled, hide loader icon.
        HandlerHelper.removeClass loaderIconEl, 'active'

      # Add markers to map from localStorage or server data.
      Helper.AddMarkers handler, ->
        # Fit map to added markers bounds.
        handler.fitMapToBounds()
        # Center map on initial position.
        centerMap handler, center
        # Set map zoom to `ZOOM_LEVEL` value.
        handler.getMap().setZoom ZOOM_LEVEL
        startGeolocationWatch()

      # Listen for `watchIconEl` DOM click events.
      watchIconEl.addEventListener 'click', ->
        # Begin or end watching geolocation, this will implicitly toggle `active` class.
        (if Helper.isWatchingGeolocation() then endGeolocationWatch else startGeolocationWatch)()

      # Set listener for map idle event (when everything updates after move, zoom or resize),
      # updates stored map center point.
      google.maps.event.addDomListener handler.getMap(), 'idle', -> updateCenter handler

      # Set listener for map drag event, stop watching for user location change.
      google.maps.event.addDomListener handler.getMap(), 'drag', endGeolocationWatch

      # Set listener for window resize event, updates centered point on map.
      google.maps.event.addDomListener window, 'resize', -> centerMap handler

# Bind buildMap function to window so it can be accessed from other files.
window.buildMap = buildMap
