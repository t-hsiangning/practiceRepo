//
//  RippleLayer.m
//  CAReplicateRipple
//
//  Created by Kaihatsu Goro on 2016/07/19.
//  Copyright © 2016年 Kaihatsu Goro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RippleLayer.h"

static int count = 0;
static int circleLimit = 10;
static int iPadLimit = 50;
static int iPhoneLimit = 100;

static NSString *animationLayerKey = @"animationLayerKey";
static NSString *opacityAnimationKey = @"opacityAnimationKey";

@interface RippleLayer ()<CAAnimationDelegate>

@property (nonatomic, strong) CAShapeLayer *roundLayer;
@property (nonatomic, strong) CAAnimationGroup *rippleAnimationGroup;

@end

@implementation RippleLayer
- (instancetype)init {
    if ( [(NSString*)[UIDevice currentDevice].model hasPrefix:@"iPad"]) {
        circleLimit = iPadLimit;
    } else {
        circleLimit = iPhoneLimit;
    }
    if (self = [super init]) {
        [self addSublayer:self.roundLayer];
        [self setDefault];
        [self setUp];
    }
    return self;
}

// MARK - public
- (void)startAnimation {
    if (count >= circleLimit) {
        return;
    }
    
    [self setCircleAnimation];
    [self.roundLayer addAnimation:self.rippleAnimationGroup forKey:@"ripples"];
}

- (void)startAnimation:(UIColor*)color {
    self.circleColor = color;
    [self setUp];
    [self setCircleAnimation];
    [self.rippleAnimationGroup setValue:self.roundLayer forKey:opacityAnimationKey];
    [self.roundLayer addAnimation:self.rippleAnimationGroup forKey:@"ripples"];
}

- (void)stopAnimation {
    [self removeAllAnimations];
}

- (void)pauseAnimation {
    CFTimeInterval pausedTime = [self.roundLayer convertTime:CACurrentMediaTime() fromLayer:nil];
    self.timeOffset = pausedTime;
    self.speed = 0.0;
}

- (void)resumeAnimation {
    CFTimeInterval pausedTime, timeSincePause;
    pausedTime = [self timeOffset];
    self.speed = 1.0;
    self.timeOffset = 0.0;
    self.beginTime = 0.0;
    timeSincePause = [self convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    self.beginTime = timeSincePause;
}

// MARK - private
- (void)setUp {
    // for duplicate layer setting
    self.backgroundColor = [UIColor clearColor].CGColor;
    self.repeatCount = self.rippleRepeatCount;
    self.instanceCount = self.rippleNumber;
    self.instanceDelay = self.delayTime;
    self.speed = 1.0;
    // for circle layer setting
    self.roundLayer.borderColor = self.circleColor.CGColor;
}

- (void)setCircleAnimation {
    self.rippleAnimationGroup.duration = self.animationDuration;
    self.rippleAnimationGroup.repeatCount = self.rippleRepeatCount;
    self.rippleAnimationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    
    // become larger
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
    scaleAnimation.fromValue = @0.0;
    scaleAnimation.toValue = @1.0;
    scaleAnimation.duration = self.animationDuration;
    
    // fade animation sin(x) setting
    NSUInteger fps = 24;
    NSUInteger frameCount = (NSUInteger)self.animationDuration*fps;
    NSMutableArray *keytimes = [NSMutableArray arrayWithCapacity:frameCount +1];
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:frameCount +1];
    for (double i=0, add = (double)1/frameCount; i<=1.0; i+=add) {
        [keytimes addObject:@(i)];
    }
    [keytimes addObject:@(1)];
    CGFloat amp = 0.5; // amplitude
    CGFloat add = M_PI/frameCount;
    for (NSUInteger i=0; i<frameCount; i++) {
        CGFloat x = amp*sin((double)i*add);
        [values addObject:@(x)];
    }
    [values addObject:@(0)];
    // fade animation
    CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    //opacityAnimation.values = @[@0.0, @0.5, @0.0];
    //opacityAnimation.keyTimes = @[@0.0, @0.5, @1.0];
    opacityAnimation.values   = values;
    opacityAnimation.keyTimes = keytimes;
    opacityAnimation.duration = self.animationDuration;
    self.rippleAnimationGroup.animations = @[opacityAnimation, scaleAnimation];
    //self.rippleAnimationGroup.removedOnCompletion = NO;
    //self.rippleAnimationGroup.fillMode = kCAFillModeForwards;
    self.rippleAnimationGroup.delegate = self;
    
}

// set default and initialize value
- (void)setDefault {
    self.radius = 100;
    self.rippleNumber = 1;
    self.rippleRepeatCount = 1;
    self.circleColor = [UIColor blueColor];
    self.animationDuration = 5;
    self.delayTime = 0.5;
    self.roundLayer.borderColor = self.circleColor.CGColor;
    self.roundLayer.backgroundColor = [UIColor clearColor].CGColor;
    self.isAnimation = NO;
}

// MARK - setter
- (void)setRadius:(CGFloat)radius {
    _radius = radius;
    CGFloat round = radius * 2;
    self.roundLayer.bounds = CGRectMake(0, 0, round, round);
    self.roundLayer.cornerRadius = radius;
    self.roundLayer.borderWidth = 3.0;
    
}
/*
- (void)setRippleNumber:(CGFloat)rippleNumber {
    if (rippleNumber > 0) {
        //self.instanceCount = rippleNumber;
        _rippleNumber = rippleNumber;
        [self setUp];
    }
}
*/
- (void)setRippleRepeatCount:(CGFloat)rippleRepeatCount { // ok
    if (rippleRepeatCount > 0) {
        //self.repeatCount = rippleRepeatCount;
        _rippleRepeatCount = rippleRepeatCount;
        [self setUp];
    }
}

- (void)setAnimationDuration:(NSTimeInterval)animationDuration {
    _animationDuration = animationDuration;
}

- (void)setCircleColor:(UIColor *)circleColor {
    _circleColor = circleColor;
    [self setUp];
}

// MARK - getter
- (CAShapeLayer*)roundLayer {
    if (!_roundLayer) {
        _roundLayer = [CAShapeLayer new];
        _roundLayer.contentsScale = [UIScreen mainScreen].scale;
        _roundLayer.opacity = 0;
    }
    return _roundLayer;
}

- (CAAnimationGroup*)rippleAnimationGroup {
    if (!_rippleAnimationGroup) {
        _rippleAnimationGroup = [CAAnimationGroup animation];
    }
    return _rippleAnimationGroup;
}

- (void)animationDidStart:(CAAnimation *)anim {
    count++;
    self.isAnimation = YES;
    //NSLog(@"animationDidStart");
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    count--;
    self.isAnimation = NO;
    //NSLog(@"%@",(flag==YES)?@"finished":@"not finished");
    /*if (flag) {
        [self.roundLayer removeFromSuperlayer];
        //[self removeFromSuperlayer];
        self.roundLayer = nil;
    }
    if (self.roundLayer) {
        [self.roundLayer removeFromSuperlayer];
    }
    CALayer *layer = [anim valueForKey:@"parentLayer"];
    if (layer) {
        [layer removeFromSuperlayer];
    }*/
    [self removeAllAnimations];
}

@end
