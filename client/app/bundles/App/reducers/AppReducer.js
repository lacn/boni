import immutable from 'seamless-immutable';

import actionTypes from '../constants/AppConstants';
import {fetchVersion} from '../helpers/api';

export const initialState = immutable({
  restaurants: null,
  zoom: 9,
  center: {
    lat: 46.12,
    lng: 14.82
  },
  loading: false
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

    default:
      return state;
  }
}
