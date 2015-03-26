
###
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

