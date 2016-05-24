import React, { PropTypes } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';

import MapsWidget from '../components/MapsWidget';
import * as AppActionCreators from '../actions/AppActionCreators';

function mapStateToProps(state) {
  // Which part of the Redux global state does our component want to receive as props?
  // Note the use of `` to prefix the property name because the value is of type Immutable.js
  return state.AppStore;
}

function mapDispatchToProps(dispatch) {
  return {
    actions: bindActionCreators(AppActionCreators, dispatch)
  };
}

// Simple example of a React "smart" component
const App = ({ restaurants, zoom, center, isClient, actions }) => {
  if (isClient && !restaurants) {
    actions.versionRequest(actions);
    actions.locationRequest(actions);
  }

  // This uses the ES2015 spread operator to pass properties as it is more DRY
  // This is equivalent to:
  // <MapsWidget AppStore={AppStore} actions={actions} />
  return (
    <MapsWidget isClient={isClient} { ...{restaurants, zoom, center} } />
  );
};

App.propTypes = {
  restaurants: PropTypes.array,
  zoom: PropTypes.number,
  center: PropTypes.object,
  isClient: PropTypes.bool,
  actions: PropTypes.object
};

// Don't forget to actually use connect!
// Note that we don't export App, but the redux "connected" version of it.
// See https://github.com/reactjs/react-redux/blob/master/docs/api.md#examples
export default connect(mapStateToProps, mapDispatchToProps)(App);
