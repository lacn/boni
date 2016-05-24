// This file is our manifest of all reducers for the app.
// See also /client/app/bundles/App/store/AppStore.jsx
// A real world app will likely have many reducers and it helps to organize them in one file.
import AppReducer, { initialState as AppState } from './AppReducer';

export default {
  AppStore: AppReducer,
};

export const initialStates = {
  AppState,
};
