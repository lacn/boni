/* eslint no-console: 0 */

// This logger should be configured not to run in a production environment.
// See https://github.com/petehunt/webpack-howto#6-feature-flags for how you might turn this
// off for production.
export default function logger() {
  return next => action => {
    // Call the next dispatch method in the middleware chain.
    const result = next(action);

    // const immutableState = getState();

    // This will likely be the action itself, unless
    // a middleware further in chain changed it.
    return result;
  };
}
