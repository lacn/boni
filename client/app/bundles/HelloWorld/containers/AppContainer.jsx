import React, { PropTypes } from 'react';
import MapsWidget from '../components/MapsWidget';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import Immutable from 'seamless-immutable';
import * as helloWorldActionCreators from '../actions/helloWorldActionCreators';

function select(state) {
  // Which part of the Redux global state does our component want to receive as props?
  // Note the use of `` to prefix the property name because the value is of type Immutable.js
  return { helloWorldStore: state.helloWorldStore };
}

// Simple example of a React "smart" component
const App = (props) => {
  const { dispatch, helloWorldStore } = props;
  const actions = bindActionCreators(helloWorldActionCreators, dispatch);
  const { updateName } = actions;
  const { restaurants, zoom, center } = helloWorldStore;

  // This uses the ES2015 spread operator to pass properties as it is more DRY
  // This is equivalent to:
  // <MapsWidget helloWorldStore={helloWorldStore} actions={actions} />
  return (
    <div style={{width: '100vw', height: '100vh'}}>
      <MapsWidget { ...{restaurants, zoom, center} } />
    </div>
  );
};

App.propTypes = {
  dispatch: PropTypes.func.isRequired,

  // This corresponds to the value used in function select above.
  // We prefix all property and variable names pointing to Immutable.js objects with ''.
  // This allows us to immediately know we don't call helloWorldStore['someProperty'], but
  // instead use the Immutable.js `get` API for Immutable.Map
  helloWorldStore: PropTypes.object.isRequired,
};

// Don't forget to actually use connect!
// Note that we don't export App, but the redux "connected" version of it.
// See https://github.com/reactjs/react-redux/blob/master/docs/api.md#examples
export default connect(select)(App);
