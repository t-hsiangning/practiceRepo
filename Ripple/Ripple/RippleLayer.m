//
//  RippleLayer.m
//  CAReplicateRipple
//
//  Created by Kaihatsu Goro on 2016/07/19.
//  Copyright © 2016年 Kaihatsu Goro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RippleLayer.h"

static NSString *animationLayerKey = @"animationLayerKey";
static NSString *rippleAnimationKey = @"rippleAnimationKey";
static NSTimeInterval animationDuration = 5; // the animation speed, the biggger the slower

@interface RippleLayer ()<CAAnimationDelegate>

//@property NSTimeInterval animationDuration;

@end

@implementation RippleLayer
- (instancetype)init {

    if (self = [super init]) {
        [self setDefault];
        [self setUp];
    }
    return self;
}

// MARK - public
- (void)startAnimation {
    
}

- (void)startAnimation:(UIColor*)color {
    
    [self setUp];
    self.borderColor = color.CGColor;
    [self addAnimation:[self getRippleAnimationGroup] forKey:rippleAnimationKey];
}

- (void)stopAnimation {
    [self removeAllAnimations];
}

- (void)pauseAnimation {
    CFTimeInterval pausedTime = [self convertTime:CACurrentMediaTime() fromLayer:nil];
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
    self.speed = 1.0;
}

- (CAAnimationGroup*)getRippleAnimationGroup {
    
    CAAnimationGroup *animeGroup = [CAAnimationGroup animation];
    animeGroup.duration = animationDuration;
    animeGroup.repeatCount = 1;
    animeGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    [animeGroup setValue:self forKey:animationLayerKey];
    
    // become larger
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
    scaleAnimation.fromValue = @0.0;
    scaleAnimation.toValue = @1.0;
    scaleAnimation.duration = animationDuration;
    
    // fade animation sin(x) setting
    NSUInteger fps = 24;
    NSUInteger frameCount = (NSUInteger)animationDuration*fps;
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
    opacityAnimation.values   = values; // orig 0.0 - 0.5 - 0.0
    opacityAnimation.keyTimes = keytimes; // orig 0.0 - 0.5 - 1.0
    opacityAnimation.duration = animationDuration;
    
    animeGroup.animations = @[opacityAnimation, scaleAnimation];
    animeGroup.removedOnCompletion = NO;
    animeGroup.fillMode = kCAFillModeForwards;
    animeGroup.delegate = self;
    
    return animeGroup;
}

// set default and initialize value
- (void)setDefault {
    self.isAnimation = NO;
}

- (void)animationDidStart:(CAAnimation *)anim {
    //count++;
    self.isAnimation = YES;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    //count--;
    self.isAnimation = NO;
    self.hidden = YES;
    [self removeAllAnimations];
    
}

@end
