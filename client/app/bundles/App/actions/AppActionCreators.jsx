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
