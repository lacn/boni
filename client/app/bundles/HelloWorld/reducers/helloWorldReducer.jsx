import Immutable from 'seamless-immutable';

import actionTypes from '../constants/helloWorldConstants';

export const initialState = Immutable({
  restaurants: {},
  zoom: 9,
  center: {
    lat: 46.12,
    lng: 14.82
  }
});

export default function helloWorldReducer(state = initialState, action) {
  const { type, name } = action;

  switch (type) {
    case actionTypes.HELLO_WORLD_NAME_UPDATE:
      return state.set('name', name);

    default:
      return state;
  }
}
