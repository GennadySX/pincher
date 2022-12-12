//
//  RNPincherView.h
//  ReactNativePincher
//
//  Created by Gennady Sabirovsky on 08.08.2022.
//  Copyright © 2022 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <React/RCTView.h>

NS_ASSUME_NONNULL_BEGIN

@interface RNPincherView : RCTView<UIGestureRecognizerDelegate>

@property (nonatomic) CGFloat minimumZoomScale;
@property (nonatomic) CGFloat maximumZoomScale;
@property (nonatomic) CGFloat animateDuration;

@end

NS_ASSUME_NONNULL_END
