import React, { PropTypes } from 'react';
import { GoogleMapLoader, GoogleMap } from 'react-google-maps';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';

import * as MapsWidgetActionCreators from '../actions/MapsWidgetActionCreators';
import RestaurantMarker from './RestaurantMarker';

class MapsWidget extends React.Component {
  static propTypes = {
    restaurants: PropTypes.array,
    zoom: PropTypes.number.isRequired,
    center: PropTypes.object.isRequired,
    actions: PropTypes.object,
    isClient: PropTypes.bool
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
        key={i}
        {...({...props, ...this.props.actions, mapHolderRef: this.refs.map, i})}
      />
    ));
  }

  render() {
    const {center, zoom} = this.props;

    return (
      <GoogleMapLoader
        containerElement={
          <div style={{width: '100vw', height: '100vh'}}></div>
        }
        googleMapElement={
          <GoogleMap ref="map" defaultCenter={center} defaultZoom={zoom}>
            { this.renderRestaurants() }
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
