export default function getGeolocation(actionCreators) {
  if (!navigator.geolocation) {
    actionCreators.locationResponse({
      locationError: 'Geolocation is not supported'
    });
    return;
  }

  navigator.geolocation.getCurrentPosition(
    (position) => actionCreators.locationResponse({
      location: {
        lat: position.coords.latitude,
        lng: position.coords.longitude
      }
    }),
    () => actionCreators.locationResponse({
      locationError: 'Unable to retrieve location.'
    })
  );
}
