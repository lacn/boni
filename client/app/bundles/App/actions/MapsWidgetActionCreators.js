import actionTypes from '../constants/AppConstants';

export function handleOnClick(i) {
  return {
    type: actionTypes.MAP_MARKER_CLICK,
    i
  };
}

export function handleOnClose() {
  return {
    type: actionTypes.MAP_INFO_CLOSE,
  };
}

export function toggleLocationWatch(actionCreators, forcedValue) {
  return {
    type: actionTypes.MAP_GEOLOCATON_TOGGLE_WATCH,
    actionCreators,
    forcedValue
  };
}
