import 'whatwg-fetch';

import {
  VERSION_ENDPOINT,
  RESTAURANTS_ENDPOINT,
  STORAGE_VERSION_KEY,
  STORAGE_RESTAURANTS_KEY} from '../constants/AppConstants';

import {getValue, storeValue} from './localStorageManager';

import {restaurantsResponse} from '../actions/AppActionCreators';

function fetchApi(endPoint) {
  return fetch(`${location.pathname.substring(1)}/${endPoint}`);
}

export function fetchRestaurants() {
  fetchApi(RESTAURANTS_ENDPOINT)
    .then(res => res.json())
    .then(restaurants => {
      storeValue(STORAGE_RESTAURANTS_KEY, restaurants);
      return restaurants;
    });
}

export function fetchVersion() {
  fetchApi(VERSION_ENDPOINT)
    .then(res => res.json())
    .then(json => json.version)
    .then(version => {
      const currentVersion = getValue(STORAGE_VERSION_KEY).version;
      if (!currentVersion || currentVersion < version) {
        storeValue(STORAGE_VERSION_KEY, version);
        return fetchRestaurants();
      }
      return getValue(STORAGE_RESTAURANTS_KEY);
    })
    .then(restaurantsResponse);
}
