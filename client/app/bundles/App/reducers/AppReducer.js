import immutable from 'seamless-immutable';

import actionTypes, {MAP_COUNTRY_LOCATION} from '../constants/AppConstants';
import {fetchVersion} from '../helpers/api';
import getGeolocation from '../helpers/getGeolocation';

export const initialState = immutable({
  restaurants: null,
  center: MAP_COUNTRY_LOCATION,
  loading: false,
  loadingLocation: false,
  location: null,
  locationError: '',
});

function mapRestaurants(restaurants, showInfoFn = () => false) {
  return {
    restaurants: (restaurants || []).map((r, i) => ({
      ...r,
      showInfo: showInfoFn(r, i)
    }))
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
      getGeolocation(action.actionCreators);
      return state.merge({ loadingLocation: true });

    case actionTypes.LOCATION_RESPONSE:
      return state.merge({
        location: action.location,
        locationError: action.locationError,
        loadingLocation: false
      });

    default:
      return state;
  }
}
