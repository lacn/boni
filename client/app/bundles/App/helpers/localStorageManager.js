import {STORAGE_BASE_KEY} from '../constants/AppConstants';

function getFullKey(key) {
  return `${STORAGE_BASE_KEY}_${key}`;
}

export function storeValue(key, value) {
  localStorage[getFullKey(key)] = JSON.stringify(value);
}

export function getValue(key) {
  const value = localStorage[getFullKey(key)];
  return value ? JSON.parse(value) : {};
}
