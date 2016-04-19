import mirrorCreator from 'mirror-creator';

const actionTypes = mirrorCreator([
  'RESTAURANTS_RESPONSE',
  'VERSION_REQUEST'
]);

export default actionTypes;

export const VERSION_ENDPOINT = '/version';
export const RESTAURANTS_ENDPOINT = '/restaurants';
export const STORAGE_BASE_KEY = 'restaurants_cache';
export const STORAGE_VERSION_KEY = 'version';
export const STORAGE_RESTAURANTS_KEY = 'restaurants';
