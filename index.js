import PropTypes from 'prop-types';
import * as React from 'react';
import { Dimensions, requireNativeComponent, StyleSheet, View, Platform } from 'react-native';
const height = Dimensions.get('window').height;

if(Platform.OS == 'android'){
    const MapboxNavigation = (props) => {
        return <RNMapboxNavigation style={styles.flex} {...props} />;
      };
      
      MapboxNavigation.propTypes = {
        origin: PropTypes.array.isRequired,
        destination: PropTypes.array.isRequired,
        waypoints: PropTypes.array.isRequired,
        shouldSimulateRoute: PropTypes.bool,
        onLocationChange: PropTypes.func,
        onRouteProgressChange: PropTypes.func,
        onError: PropTypes.func,
        onCancelNavigation: PropTypes.func,
        onArrive: PropTypes.func,
        showsEndOfRouteFeedback: PropTypes.bool,
      };
      
      const RNMapboxNavigation = requireNativeComponent(
        'MapboxNavigation',
        MapboxNavigation
      );
      
      const styles = StyleSheet.create({
        flex: {
          flex: 1,
          height: height-120
        },
      });
      
}else{
    const MapboxNavigation = requireNativeComponent('MapboxNavigation');
}


export default MapboxNavigation;