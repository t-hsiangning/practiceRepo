//
//  RippleLayer.h
//  CAReplicateRipple
//
//  Created by Kaihatsu Goro on 2016/07/19.
//  Copyright © 2016年 Kaihatsu Goro. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface RippleLayer : CAReplicatorLayer

@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) CGFloat rippleNumber;
@property (nonatomic, assign) CGFloat rippleRepeatCount;
@property (nonatomic, assign) UIColor *circleColor;
@property (nonatomic, assign) NSTimeInterval delayTime;
@property (nonatomic, assign) NSTimeInterval animationDuration;
@property BOOL isAnimation;

- (void)startAnimation;
- (void)startAnimation:(UIColor*)color;
//- (void)stopAnimation;
//- (void)pauseAnimation;
//- (void)resumeAnimation;

@end
