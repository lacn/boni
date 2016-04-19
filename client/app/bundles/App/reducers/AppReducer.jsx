import Immutable from 'seamless-immutable';

import actionTypes from '../constants/AppConstants';
import {fetchVersion} from '../helpers/api';

export const initialState = Immutable({
  restaurants: [],
  zoom: 9,
  center: {
    lat: 46.12,
    lng: 14.82
  },
  loading: false
});

export default function AppReducer(state = initialState, action) {

  switch (action.type) {
    case actionTypes.VERSION_REQUEST:
      fetchVersion();
      return state.merge({ loading: true });

    case actionTypes.RESTAURANTS_RESPONSE:
      return state.merge({ restaurants: action.restaurants, loading: false });

    default:
      return state;
  }
}
