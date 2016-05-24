import React, {PropTypes} from 'react';
import cx from 'classnames';

const FollowLocation = ({loadingLocation, locationWatch, toggleLocationWatch}) => (
  <div onClick={() => toggleLocationWatch()}>
    <span
      id="follow-location"
      className={cx('icon-direction', {active: locationWatch})}
    />
    <span
      id="location-loading"
      className={cx('icon-spinner animate-spin', {active: loadingLocation})}
    />
  </div>
);

FollowLocation.propTypes = {
  loadingLocation: PropTypes.bool,
  locationWatch: PropTypes.bool,
  toggleLocationWatch: PropTypes.func
};

export default FollowLocation;
