import React, {PropTypes} from 'react';
import cx from 'classnames';

const FollowLocation = ({loadingApp, loadingLocation, locationWatch, toggleLocationWatch}) => (
  <div
    onClick={() => toggleLocationWatch()}
    className={cx('follow-location-wrapper', {invisible: loadingApp})}
  >
    <button className="follow-location">
      <div className={cx('follow-location-icon', {loading: loadingLocation, active: locationWatch})}/>
    </button>
  </div>
);

FollowLocation.propTypes = {
  loadingApp: PropTypes.bool,
  loadingLocation: PropTypes.bool,
  locationWatch: PropTypes.bool,
  toggleLocationWatch: PropTypes.func
};

export default FollowLocation;
