import React, { PropTypes } from 'react';
import { GoogleMapLoader, GoogleMap } from 'react-google-maps';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';

import * as MapsWidgetActionCreators from '../actions/MapsWidgetActionCreators';
import RestaurantMarker from './RestaurantMarker';
import {MAP_COUNTRY_ZOOM, MAP_GEOLOCATON_ZOOM} from '../constants/AppConstants';

class MapsWidget extends React.Component {
  static propTypes = {
    restaurants: PropTypes.array,
    center: PropTypes.object.isRequired,
    actions: PropTypes.object.isRequired,
    isClient: PropTypes.bool,
    location: PropTypes.object,
    loadingLocation: PropTypes.bool,
    locationError: PropTypes.string,
  };

  componentWillMount() {
    if (this.props.isClient) {
      window.addEventListener('keyup', this.closeOnEsc);
    }
  }

  componentWillUnmount() {
    if (this.props.isClient) {
      window.removeEventListener('keyup', this.closeOnEsc);
    }
  }

  closeOnEsc = (keyUpEvent) => {
    if (keyUpEvent.keyCode === 27) {
      this.props.actions.handleOnClose();
    }
  }

  locationLoadedAndExists(props = this.props) {
    return Boolean(!props.loadingLocation && props.location);
  }

  renderRestaurants() {
    if (!this.props.restaurants) {
      return null;
    }

    return this.props.restaurants.asMutable().map((props, i) => (
      <RestaurantMarker
        key={i}
        {...({...props, ...this.props.actions, mapHolderRef: this.refs.map, i})}
      />
    ));
  }

  render() {
    const {center, location} = this.props;

    const locationLoadedAndExists = this.locationLoadedAndExists();
    console.log('locationLoadedAndExists', locationLoadedAndExists)
    const defaultCenter = locationLoadedAndExists ? location : center;
    const defaultZoom = locationLoadedAndExists ? MAP_GEOLOCATON_ZOOM : MAP_COUNTRY_ZOOM;

    console.log(location)
    console.log('defaultCenter', defaultCenter)
    console.log(defaultZoom)

    return (
      <GoogleMapLoader
        containerElement={
          <div style={{width: '100vw', height: '100vh'}}></div>
        }
        googleMapElement={
          <GoogleMap
            ref="map"
            center={defaultCenter}
            zoom={defaultZoom}
          >
            {this.renderRestaurants()}
          </GoogleMap>
        }
      />
    );
  }
}

function mapStateToProps(state) {
  return state.AppStore;
}

function mapDispatchToProps(dispatch) {
  return {
    actions: bindActionCreators(MapsWidgetActionCreators, dispatch)
  };
}

export default connect(mapStateToProps, mapDispatchToProps)(MapsWidget);
