import React, { PropTypes } from 'react';

const RestaurantMarker = ({lat, lng}) => (
  (lat && lng)
    ? (<div lat={lat} lng={lng}></div>)
    : null
);

RestaurantMarker.propTypes = {
  lat: PropTypes.number.isRequired,
  lng: PropTypes.number.isRequired,
};

export default RestaurantMarker;
