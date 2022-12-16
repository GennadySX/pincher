//
//  RNPincherView.m
//  ReactNativePincher
//
//  Created by Gennady Sabirovsky on 08.08.2022.
//  Copyright © 2022 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RNPincherView.h"

@implementation RNPincherView

BOOL isActive = NO;
NSUInteger lastNumberOfTouches;
UIView *initialSuperView;
NSUInteger initialIndex;
CGRect initialFrame;
CGPoint initialTouchPoint;
CGPoint initialAnchorPoint;
CGPoint lastTouchPoint;
UIView *backgroundView;

- (instancetype)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame])) {
    _minimumZoomScale = 1.0;
    _maximumZoomScale = 3.0;
    _animateDuration = 0.2;
  }
  return self;
}

- (void)resetGestureState
{
  isActive = NO;
  lastNumberOfTouches = 0;
  initialSuperView = nil;
  initialIndex = -1;
  initialFrame = CGRectZero;
  initialTouchPoint = CGPointZero;
  initialAnchorPoint = CGPointZero;
  lastTouchPoint = CGPointZero;
  backgroundView = nil;
}

- (void)setupGesture
{
  UIPinchGestureRecognizer *gestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
  gestureRecognizer.delegate = self;
  [self addGestureRecognizer:gestureRecognizer];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
  if (isActive) {
    return NO;
  }
  UIView *view = gestureRecognizer.view;
  UIWindow *window = UIApplication.sharedApplication.keyWindow;
  CGPoint absoluteOrigin = [view.superview convertPoint:view.frame.origin toView:window];
  if (isnan(absoluteOrigin.x) || isnan(absoluteOrigin.y)) {
    return NO;
  }
  return YES;
}

- (void)handlePinchGesture:(UIPinchGestureRecognizer *)gestureRecognizer
{
  UIView *view = gestureRecognizer.view;
  UIWindow *window = UIApplication.sharedApplication.keyWindow;
  if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
    lastNumberOfTouches = gestureRecognizer.numberOfTouches;
    initialFrame = view.frame;
    initialTouchPoint = [gestureRecognizer locationInView:window];
    isActive = YES;
    initialSuperView = view.superview;
    initialIndex = [initialSuperView.subviews indexOfObject:view];
    initialAnchorPoint = view.layer.anchorPoint;

    CGPoint center = [gestureRecognizer locationInView:view];
    CGPoint absoluteOrigin = [view.superview convertPoint:view.frame.origin toView:window];
    CGPoint anchorPoint = CGPointMake(center.x/initialFrame.size.width, center.y/initialFrame.size.height);

    backgroundView = [UIView new];
    backgroundView.backgroundColor = UIColor.blackColor;
    backgroundView.frame = window.frame;
    [window addSubview:backgroundView];
    [window addSubview:view];

    view.layer.anchorPoint = anchorPoint;
    view.center = center;
    view.frame = CGRectMake(absoluteOrigin.x, absoluteOrigin.y, initialFrame.size.width, initialFrame.size.height);
    [initialSuperView setNeedsLayout];
    [view setNeedsLayout];
  }

  if (gestureRecognizer.state == UIGestureRecognizerStateBegan ||
      gestureRecognizer.state == UIGestureRecognizerStateChanged) {

    CGPoint currentTouchPoint = [gestureRecognizer locationInView:window];

    if (lastNumberOfTouches != gestureRecognizer.numberOfTouches) {
      lastNumberOfTouches = gestureRecognizer.numberOfTouches;
      CGFloat deltaX = currentTouchPoint.x - lastTouchPoint.x;
      CGFloat deltaY = currentTouchPoint.y - lastTouchPoint.y;
      initialTouchPoint = CGPointMake(initialTouchPoint.x + deltaX, initialTouchPoint.y + deltaY);
    }

    CGFloat scale = MAX(MIN(gestureRecognizer.scale, _maximumZoomScale), _minimumZoomScale);
    CGPoint translate = CGPointMake(currentTouchPoint.x - initialTouchPoint.x, currentTouchPoint.y - initialTouchPoint.y);

    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformTranslate(transform, translate.x, translate.y);
    transform = CGAffineTransformScale(transform, scale, scale);
    view.transform = transform;

    backgroundView.layer.opacity = MIN(scale - 1., .7);
    lastTouchPoint = currentTouchPoint;
  }

  if (gestureRecognizer.state == UIGestureRecognizerStateEnded ||
      gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
    [UIView animateWithDuration:0.5 delay:0. usingSpringWithDamping:1 initialSpringVelocity:.6 options:0 animations:^{
      gestureRecognizer.view.transform = CGAffineTransformIdentity;
      backgroundView.layer.opacity = 0.1;
    } completion:^(BOOL finished) {
      [backgroundView removeFromSuperview];
      [initialSuperView insertSubview:view atIndex:initialIndex];
      view.layer.anchorPoint = initialAnchorPoint;
      view.frame = initialFrame;
      [self resetGestureState];
    }];
  }
}

@end
