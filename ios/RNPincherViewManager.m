//
//  RNPincherViewManager.m
//  ReactNativePincher
//
//  Created by Gennady Sabirovsky on 08.08.2022.
//  Copyright © 2022 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RNPincherViewManager.h"
#import "RNPincherView.h"

@implementation RNPincherViewManager

RCT_EXPORT_MODULE(PincherView)

- (RNPincherView *)view
{
  return [RNPincherView new];
}

RCT_EXPORT_VIEW_PROPERTY(minimumZoomScale, CGFloat);
RCT_EXPORT_VIEW_PROPERTY(maximumZoomScale, CGFloat);
RCT_EXPORT_VIEW_PROPERTY(animateDuration, CGFloat);

@end
