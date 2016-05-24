import actionTypes from '../constants/AppConstants';

export function versionRequest(actionCreators) {
  return {
    type: actionTypes.VERSION_REQUEST,
    actionCreators
  };
}

export function restaurantsResponse(restaurants) {
  return {
    type: actionTypes.RESTAURANTS_RESPONSE,
    restaurants
  };
}

export function locationRequest(actionCreators) {
  return {
    type: actionTypes.LOCATION_REQUEST,
    actionCreators
  };
}

export function locationResponse({location = null, locationError = ''}) {
  return {
    type: actionTypes.LOCATION_RESPONSE,
    location,
    locationError
  };
}
