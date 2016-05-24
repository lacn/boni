import React, {PropTypes} from 'react';
import {OverlayView} from 'react-google-maps';

const LocationMarker = ({locationWatch, position, mapHolderRef}) => (
  locationWatch
   ? (
    <OverlayView
      position={position}
      mapHolderRef={mapHolderRef}
      mapPaneName={OverlayView.OVERLAY_LAYER}
    >
      <div className="location-marker"></div>
    </OverlayView>
   )
   : null
);

LocationMarker.propTypes = {
  locationWatch: PropTypes.bool.isRequired,
  position: PropTypes.object,
  mapHolderRef: PropTypes.object,
};

export default LocationMarker;
