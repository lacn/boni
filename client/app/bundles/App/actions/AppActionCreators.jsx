import actionTypes from '../constants/AppConstants';

export function versionRequest() {
  console.log('versionRequest action');
  return {
    type: actionTypes.VERSION_REQUEST,
  };
}

export function restaurantsResponse(restaurants) {
  return {
    type: actionTypes.RESTAURANTS_RESPONSE,
    restaurants
  };
}
