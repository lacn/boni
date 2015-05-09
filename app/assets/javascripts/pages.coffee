
###*
 * Level of map zoom on page load.
 * @type {Number}
###
ZOOM_LEVEL = 15

Helper = new HandlerHelper center

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

buildMap = (center) ->
  window.handler = Gmaps.build 'Google'
  handler.buildMap
    internal:
      # Build map in DOM element with id `map`.
      id: 'map'
    # Callback function (called when map is initialized).
    ->
      # Use centerMap function to center map on initial position.
      centerMap handler, center
      handler.getMap().setZoom ZOOM_LEVEL

      # Add markers with (static) helper function,
      # it's using json data from rails.
      Helper.AddMarkers handler

      # Set listener for map idle event (when everything updates after move, zoom or resize),
      # updates stored map center point.
      google.maps.event.addDomListener handler.getMap(), 'idle', -> updateCenter handler

      # Set listener for window resize event, updates centered point on map.
      google.maps.event.addDomListener window, 'resize', -> centerMap handler


window.buildMap = buildMap
