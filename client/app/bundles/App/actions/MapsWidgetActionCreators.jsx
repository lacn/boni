import actionTypes from '../constants/AppConstants';

export function handleOnClick(i) {
  return {
    type: actionTypes.MAP_MARKER_CLICK,
    i
  };
}

export function handleOnClose(i) {
  return {
    type: actionTypes.MAP_INFO_CLOSE,
    i
  };
}
