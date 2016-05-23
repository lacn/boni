import Immutable from 'seamless-immutable';

import actionTypes from '../constants/AppConstants';
import {fetchVersion} from '../helpers/api';

export const initialState = Immutable({
  restaurants: null,
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
      fetchVersion(action.actionCreators);
      return state.merge({ loading: true });

    case actionTypes.RESTAURANTS_RESPONSE:
      return state.merge({ restaurants: action.restaurants.map(r => Object.assign(r, {showInfo: false})), loading: false });

    case actionTypes.MAP_MARKER_CLICK:
      return state.setIn(['restaurants', action.i, 'showInfo'], true);

    case actionTypes.MAP_INFO_CLOSE:
      return state.setIn(['restaurants', action.i, 'showInfo'], false);

    default:
      return state;
  }
}
