import React, { PropTypes } from 'react';
import { InfoWindow } from 'react-google-maps';

const RestaurantInfoWindow = ({name, address, city, price, handleOnClose}) => (
  <InfoWindow onCloseclick={handleOnClose}>
    <div>
      <strong>{name}</strong>
      <p>{address}, {city}</p>
      <p>{price}€</p>
    </div>
  </InfoWindow>
);

RestaurantInfoWindow.propTypes = {
  name: PropTypes.string,
  address: PropTypes.string,
  city: PropTypes.string,
  price: PropTypes.string,
  handleOnClose: PropTypes.func,
};

export default RestaurantInfoWindow;
