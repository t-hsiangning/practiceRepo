//
//  CARippleView.m
//  Ripple
//
//  Created by Kaihatsu Goro on 2016/11/17.
//  Copyright © 2016年 Kaihatsu Goro. All rights reserved.
//

#import "CARippleView.h"
#import "RippleLayer.h"
#import <UIKit/UIKit.h>

@interface CARippleView()

@property UIColor *specificColor;
@property NSTimer *timer;

@property BOOL isAnimationing;
@property BOOL isSpecificColor;


@end


@implementation CARippleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (Class)class {
    return [RippleLayer class];
}


// start ripple animation with random color
- (void)startAnimation {
    self.isSpecificColor = NO;
    self.isAnimationing = YES;
    
    [self startAnimationTimer];
}

// start ripple animation with defined color
- (void)startAnimationWith: (UIColor*)color {
    
    self.isSpecificColor = YES;
    self.specificColor = color;
    self.isAnimationing = YES;
    [self startAnimationTimer];
}

// stop animation
- (void)stopAnimation {
    self.isAnimationing = NO;
    [self stopAnimationTimer];
}

// pause animation
- (void)pauseAnimation {
    // 如果把以下兩行砍掉就會有可以邊暫停邊增加的效果。
    self.isAnimationing = NO;
    [self stopAnimationTimer];
    CFTimeInterval pausedTime;
    for (CAShapeLayer *layer in self.layer.sublayers) {
        pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
        layer.timeOffset = pausedTime;
        layer.speed = 0.0;
    }
}

// resume animation
- (void)resumeAnimation {
    self.isAnimationing = YES;
    [self startAnimationTimer];
    CFTimeInterval pausedTime, timeSincePause;
    for (CAShapeLayer *layer in self.layer.sublayers) {
        if(layer.speed == 1.0) {
            break;
        }
        pausedTime = [layer timeOffset];
        layer.speed = 1.0;
        layer.timeOffset = 0.0;
        layer.beginTime = 0.0;
        timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
        layer.beginTime = timeSincePause;
    }
}

// check is animationing or not
- (BOOL)isAnimation {
    
    return YES;
}

- (void)startAnimationTimer {
    //NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.9 target:self selector:@selector(timerRandShowCircle) userInfo:nil repeats:YES];
    //[runLoop addTimer:self.timer forMode:NSDefaultRunLoopMode];
    //[runLoop addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)stopAnimationTimer {
    [self.timer invalidate];
    self.timer = nil;
    NSLog(@"count of layer: %lu", self.layer.sublayers.count);
    
    /*for (RippleLayer *rLayer in self.layer.sublayers) { // will occur error exception
        if ([rLayer isKindOfClass:[RippleLayer class]]) {
            if (rLayer.isAnimation == NO) {
                [rLayer removeAllAnimations];
                [rLayer removeFromSuperlayer];
            }
        }
    }*/
    
    for (RippleLayer *rLayer in [self.layer.sublayers copy] ) {
        if ([rLayer isKindOfClass:[RippleLayer class]]) {
            if (rLayer.isAnimation == NO) {
                [rLayer removeAllAnimations];
                [rLayer removeFromSuperlayer];
            }
        }
    }
    
    
    
    //[NSRunLoop cancelPreviousPerformRequestsWithTarget:self selector:@selector(timerRandShowCircle) object:nil];
}

- (void)timerRandShowCircle {
    
    if (self.isAnimationing == NO) {
        return;
    }
    
    RippleLayer *rLayer = [RippleLayer layer];
    
    rLayer.position = [self getRandomPosition];
    [self setCircleLayer:rLayer withRadius:[self getRandomRadius]];
    [self.layer addSublayer:rLayer];
    if (self.isSpecificColor == YES) {
        [rLayer startAnimation:self.specificColor];
    } else {
        [rLayer startAnimation:[self getRandomColor]];
    }

}

- (CGPoint)getRandomPosition {
    int width  = self.frame.size.width + 1; // for iPad is 1024
    int height = self.frame.size.height + 1; // for iPad is 768
    int x_pos, y_pos;
    srand48(time(0));
    x_pos = arc4random() % width;
    y_pos = arc4random() % height;
    return CGPointMake(x_pos, y_pos);
}

- (UIColor*)getRandomColor {
    CGFloat red   = arc4random() % 255;
    CGFloat blue  = arc4random() % 255;
    CGFloat green = arc4random() % 255;
    return [UIColor colorWithRed:red/255 green:green/255 blue:blue/255 alpha:1];
    //return [UIColor colorWithRed:red/255 green:green/255 blue:blue/255 alpha:0.9];
}

- (CGFloat)getRandomRadius {
    CGFloat rRadius;
    if ( [(NSString*)[UIDevice currentDevice].model hasPrefix:@"iPad"]) {
        rRadius = (arc4random() % 150) + 60;
    } else {
        rRadius = (arc4random() % 100) + 25;
    }
    return rRadius;
}

- (void)setCircleLayer: (CALayer*)layer withRadius:(CGFloat)radius {
    layer.bounds = CGRectMake(0, 0, radius*2, radius*2);
    layer.cornerRadius = radius;
    layer.borderWidth = 3.0;
}




@end
