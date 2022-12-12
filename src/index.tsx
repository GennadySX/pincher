import { requireNativeComponent } from 'react-native';
import React from 'react';

const Pincher = requireNativeComponent('PincherView');

export const PincherView: React.FC<{
  minimumZoomScale?: number;
  maximumZoomScale?: number;
  animateDuration?: number;
}> = (props) => {
  return <Pincher {...props} />;
};
