import mirrorCreator from 'mirror-creator';

const actionTypes = mirrorCreator([
  'RESTAURANTS_RESPONSE',
  'VERSION_REQUEST',
  'MAP_MARKER_CLICK',
  'MAP_INFO_CLOSE',
  'LOCATION_REQUEST',
  'LOCATION_RESPONSE'
]);

export default actionTypes;

export const VERSION_ENDPOINT = '/version';
export const RESTAURANTS_ENDPOINT = '/restaurants';
export const STORAGE_BASE_KEY = 'restaurants_cache';
export const STORAGE_VERSION_KEY = 'version';
export const STORAGE_RESTAURANTS_KEY = 'restaurants';
export const MAP_GEOLOCATON_ZOOM = 15;
export const MAP_COUNTRY_ZOOM = 9;
export const MAP_COUNTRY_LOCATION = { lat: 46.12, lng: 14.82 };
