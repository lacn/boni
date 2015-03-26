
###*
 * Level of map zoom on page load.
 * @type {Number}
###
ZOOM_LEVEL = 15

###*
 * Centers the map of passed handler.
 * Using Helper object to get center (initialized from rails).
 * @param {GoogleMapsHandler} handler Handler of Google Maps object.
###
centerMap = (handler) ->
  handler.map.centerOn Helper.getCenter()

###*
 * Update center location stored in Helper object.
 * @param {GoogleMapsHandler} handler Handler of Google Maps object.
###
updateCenter = (handler) ->
  Helper.setCenter handler.map.getServiceObject().getCenter()

buildMap = ->
  window.handler = Gmaps.build 'Google'
  handler.buildMap
    internal:
      # Build map in DOM element with id `map`.
      id: 'map'
    # Callback function (called when map is initialized).
    ->
      # Use centerMap function to center map on initial position.
      centerMap handler
      handler.getMap().setZoom ZOOM_LEVEL

      # Add markers with (static) helper function,
      # it's using json data from rails.
      Helper.AddMarkers handler

  # Add event lisener for event of center changed
  google.maps.event.addListener handler.getMap(), 'center_changed', -> updateCenter handler

  # Set listener for window resize event, updates map center point.
  # The try..catch block is used in case of
  $(window).resize -> try centerMap handler catch error

window.buildMap = buildMap
