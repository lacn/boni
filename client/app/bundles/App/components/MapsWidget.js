import React, { PropTypes } from 'react';
import { GoogleMapLoader, GoogleMap } from 'react-google-maps';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';

import * as MapsWidgetActionCreators from '../actions/MapsWidgetActionCreators';
import * as AppActionCreators from '../actions/AppActionCreators';
import {MAP_COUNTRY_ZOOM, MAP_GEOLOCATON_ZOOM} from '../constants/AppConstants';
import RestaurantMarker from './RestaurantMarker';
import FollowLocation from './FollowLocation';

class MapsWidget extends React.Component {
  static propTypes = {
    restaurants: PropTypes.array,
    center: PropTypes.object.isRequired,
    actions: PropTypes.object.isRequired,
    isClient: PropTypes.bool,
    location: PropTypes.object,
    loadingLocation: PropTypes.bool,
    locationWatch: PropTypes.bool,
    locationError: PropTypes.string,
    loadingApp: PropTypes.bool,
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

  renderRestaurants() {
    if (!this.props.restaurants) {
      return null;
    }

    return this.props.restaurants.asMutable().map((props, i) => (
      <RestaurantMarker
        key={`RestaurantMarker-${i}`}
        {...({...props, ...this.props.actions, mapHolderRef: this.refs.map, i})}
      />
    ));
  }

  render() {
    const {center, location, loadingLocation, locationWatch, actions, loadingApp} = this.props;

    const locationLoadedAndExists = Boolean(!loadingLocation && location);
    const mapCenter = locationLoadedAndExists ? location : center;
    const mapZoom = locationLoadedAndExists ? MAP_GEOLOCATON_ZOOM : MAP_COUNTRY_ZOOM;

    const toggleLocationWatch = actions.toggleLocationWatch.bind(null, actions);

    return (
      <GoogleMapLoader
        containerElement={
          <div style={{width: '100vw', height: '100vh'}}></div>
        }
        googleMapElement={
          <GoogleMap
            ref="map"
            center={mapCenter}
            zoom={mapZoom}
            onCenterChanged={() => locationWatch && toggleLocationWatch(false)}
          >
            {this.renderRestaurants()}
            <FollowLocation
              loadingApp={loadingApp}
              loadingLocation={loadingLocation}
              locationWatch={locationWatch}
              toggleLocationWatch={toggleLocationWatch}
            />
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
    actions: {
      ...(bindActionCreators(AppActionCreators, dispatch)),
      ...(bindActionCreators(MapsWidgetActionCreators, dispatch)),
    }
  };
}

export default connect(mapStateToProps, mapDispatchToProps)(MapsWidget);
