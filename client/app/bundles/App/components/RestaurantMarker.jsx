import React, {Component, PropTypes} from 'react';
import {Marker, InfoWindow} from 'react-google-maps';

class RestaurantMarker extends Component {
  static propTypes = {
    lat: PropTypes.number,
    lng: PropTypes.number,
    name: PropTypes.string,
    showInfo: PropTypes.bool,
    address: PropTypes.string,
    city: PropTypes.string,
    price: PropTypes.string,
    handleOnClick: PropTypes.func,
    handleOnClose: PropTypes.func,
    mapHolderRef: PropTypes.object,
    i: PropTypes.number
  }

  shouldComponentUpdate(nextProps) {
    return this.props.showInfo !== nextProps.showInfo;
  }

  render() {
    const {
      lat,
      lng,
      name,
      showInfo,
      address,
      city,
      price,
      handleOnClick,
      handleOnClose,
      mapHolderRef,
      i
    } = this.props;

    const ref = `marker_${i}`;
    return (
      (lat && lng)
        ? (
          <Marker
            key={ref} ref={ref}
            mapHolderRef={mapHolderRef}
            position={new google.maps.LatLng(lat, lng)}
            onClick={() => handleOnClick(i)}
          >
            {
              showInfo
                ? (
                  <InfoWindow onCloseclick={() => handleOnClose(i)}>
                    <div>
                      <strong>{name}</strong>
                      <p>{address}, {city}</p>
                      <p><i>{price}€</i></p>
                    </div>
                  </InfoWindow>
                )
                : null
            }
          </Marker>
        )
        : null
    );
  }
}

export default RestaurantMarker;
