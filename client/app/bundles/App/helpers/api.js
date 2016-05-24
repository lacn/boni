import 'whatwg-fetch';

import {
  VERSION_ENDPOINT,
  RESTAURANTS_ENDPOINT,
  STORAGE_VERSION_KEY,
  STORAGE_RESTAURANTS_KEY} from '../constants/AppConstants';

import {getValue, storeValue} from './localStorageManager';

// Endpoint, including heading `/`
function getEndpointPath(endpoint) {
  const basePath = process.env.NODE_ENV === 'development' ? 'https://gresak.io/boni' : location.pathname.substring(1);
  return `${basePath}${endpoint}`;
}

export function fetchRestaurants() {
  fetch(getEndpointPath(RESTAURANTS_ENDPOINT))
    .then(res => res.json())
    .then(restaurants => {
      storeValue(STORAGE_RESTAURANTS_KEY, restaurants);
      return restaurants;
    });
}

export function fetchVersion(actionCreators) {
  fetch(getEndpointPath(VERSION_ENDPOINT))
    .then(res => res.json())
    .then(json => json.version)
    .then(version => {
      const currentVersion = getValue(STORAGE_VERSION_KEY);
      if (!currentVersion || currentVersion < version) {
        storeValue(STORAGE_VERSION_KEY, version);
        return fetchRestaurants();
      }
      return getValue(STORAGE_RESTAURANTS_KEY);
    })
    .then(actionCreators.restaurantsResponse);
}
