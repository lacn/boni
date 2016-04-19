import React, { PropTypes } from 'react';
import GoogleMap from 'google-map-react';

export default class MapsWidget extends React.Component {
  static propTypes = {
    restaurants: PropTypes.object.isRequired,
    zoom: PropTypes.number.isRequired,
    center: PropTypes.object.isRequired
  };

  render() {
    const {center, zoom} = this.props;

    return (
      <GoogleMap
        defaultCenter={center}
        defaultZoom={zoom}>
      </GoogleMap>
    );
  }
}
