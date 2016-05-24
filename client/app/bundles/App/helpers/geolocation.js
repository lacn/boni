function sendCurrentPosition(locationResponse, position) {
  locationResponse({
    location: {
      lat: position.coords.latitude,
      lng: position.coords.longitude
    }
  });
}

function watchGeolocation({locationResponse}) {
  return navigator.geolocation.watchPosition(sendCurrentPosition.bind(null, locationResponse));
}

function unwatchGeolocation({watchId}) {
  if (watchId) {
    navigator.geolocation.clearWatch(watchId);
  }
}

export function getGeolocation(locationResponse) {
  if (!navigator.geolocation) {
    locationResponse({ locationError: 'Geolocation is not supported' });
    return;
  }

  navigator.geolocation.getCurrentPosition(
    sendCurrentPosition.bind(null, locationResponse),
    () => locationResponse({ locationError: 'Unable to retrieve location.' })
  );
}

export function toggleWatch({nextLocationWatchState, ...args}) {
  return (nextLocationWatchState ? watchGeolocation : unwatchGeolocation)(args);
}
