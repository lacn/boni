import actionTypes from '../constants/AppConstants';

export function versionRequest() {
  console.log('versionRequest action');
  console.log('env', process.env.NODE_ENV);
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
