import immutable from 'seamless-immutable';

import actionTypes, {MAP_COUNTRY_LOCATION} from '../constants/AppConstants';
import {fetchVersion} from '../helpers/api';
import {getGeolocation, toggleWatch} from '../helpers/geolocation';

export const initialState = immutable({
  restaurants: null,
  center: MAP_COUNTRY_LOCATION,
  loading: false,
  loadingLocation: false,
  location: null,
  locationError: '',
  locationWatch: false,
  locationWatchId: null,
});

function mapRestaurants(restaurants, showInfoFn = () => false) {
  return {
    restaurants: (restaurants || []).map((r, i) => ({
      ...r,
      showInfo: showInfoFn(r, i)
    }))
  };
}

function nextLocationWatch(state, action) {
  return (typeof action.forcedValue !== 'undefined') ? action.forcedValue : !state.locationWatch;
}

function prepareToggleWatchArgs(state, action) {
  return {
    nextLocationWatchState: nextLocationWatch(state, action),
    locationResponse: action.actionCreators.locationResponse,
    watchId: state.watchId,
  };
}

export default function AppReducer(state = initialState, action) {
  switch (action.type) {
    case actionTypes.VERSION_REQUEST:
      fetchVersion(action.actionCreators);
      return state.merge({ loading: true });

    case actionTypes.RESTAURANTS_RESPONSE:
      return state.merge({ ...(mapRestaurants(action.restaurants)), loading: false });

    case actionTypes.MAP_MARKER_CLICK:
      return state.merge(mapRestaurants(state.restaurants, (__, i) => i === action.i));

    case actionTypes.MAP_INFO_CLOSE:
      return state.merge(mapRestaurants(state.restaurants));

    case actionTypes.LOCATION_REQUEST:
      getGeolocation(action.actionCreators.locationResponse);
      return state.merge({ loadingLocation: true });

    case actionTypes.LOCATION_RESPONSE:
      return state.merge({
        location: action.location,
        locationError: action.locationError,
        loadingLocation: false
      });

    case actionTypes.MAP_GEOLOCATON_TOGGLE_WATCH:
      return state.merge({
        locationWatch: nextLocationWatch(state, action),
        // Returns watchId, merge it in state.
        watchId: toggleWatch(prepareToggleWatchArgs(state, action))
      });

    default:
      return state;
  }
}
