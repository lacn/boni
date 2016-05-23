import React, {PropTypes} from 'react';
import {Marker} from 'react-google-maps';
import {RESTAURANT_MARKER} from '../constants/IconsBase64';
import RestaurantInfoWindow from './RestaurantInfoWindow';

const style = {
  content: `url('${RESTAURANT_MARKER}')`,
  width: 48,
  height: 48,
  userSelect: 'none'
};

const RestaurantMarker = (props) => {
  const {lat, lng, showInfo, handleOnClick} = props;

  return (
    (lat && lng)
      ? (
        <Marker position={new google.maps.LatLng(lat, lng)} onClick={handleOnClick}>
          {
            showInfo
              ? <RestaurantInfoWindow {...props}/>
              : null
          }
        </Marker>
      )
      : null
  );
};

RestaurantMarker.propTypes = {
  lat: PropTypes.number,
  lng: PropTypes.number,
  showInfo: PropTypes.bool,
  handleOnClick: PropTypes.func,
};

export default RestaurantMarker;
