import React, { PropTypes } from 'react';
import GoogleMap from 'google-map-react';

import RestaurantMarker from './RestaurantMarker';

export default class MapsWidget extends React.Component {
  static propTypes = {
    restaurants: PropTypes.array.isRequired,
    zoom: PropTypes.number.isRequired,
    center: PropTypes.object.isRequired
  };

  renderRestaurants() {
    return this.props.restaurants.map(restaurant => <RestaurantMarker {...restaurant} />);
  }

  render() {
    const {center, zoom} = this.props;

    return (
      <GoogleMap
        defaultCenter={center}
        defaultZoom={zoom}>
        { this.renderRestaurants() }
      </GoogleMap>
    );
  }
}
