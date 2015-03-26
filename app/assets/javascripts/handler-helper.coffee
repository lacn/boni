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

