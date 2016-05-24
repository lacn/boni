import { compose, createStore, applyMiddleware, combineReducers } from 'redux';

// See
// https://github.com/gaearon/redux-thunk and http://redux.js.org/docs/advanced/AsyncActions.html
// This is not actually used for this simple example, but you'd probably want to use this
// once your app has asynchronous actions.
import thunkMiddleware from 'redux-thunk';
import promiseMiddleware from 'redux-promise';
import createLogger from 'redux-logger';

import reducers, { initialStates } from '../reducers';
import blankLogger from '../../../lib/middlewares/loggerMiddleware';

export default () => {
  // This is how we get initial props Rails into redux.
  const { AppState } = initialStates;

  // Redux expects to initialize the store using an Object, not an Immutable.Map
  const initialState = {
    AppStore: AppState,
  };

  const reducer = combineReducers(reducers);
  const composedStore = compose(
    applyMiddleware(
      thunkMiddleware,
      promiseMiddleware,
      process.env.NODE_ENV === 'development' ? createLogger() : blankLogger
    )
  );
  const storeCreator = composedStore(createStore);
  const store = storeCreator(reducer, initialState);

  return store;
};
