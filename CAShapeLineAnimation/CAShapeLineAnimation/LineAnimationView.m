//
//  LineAnimationView.m
//  CAShapeLineAnimation
//
//  Created by Kaihatsu Goro on 2016/07/19.
//  Copyright © 2016年 Kaihatsu Goro. All rights reserved.
//

#import "LineAnimationView.h"

@interface LineAnimationView()
//@property NSArray* sPoint_straight_line;
//@property NSArray* ePoint_straight_line;

@property NSArray* line_st_points;
@property NSArray* line_ed_points;
@end

@implementation LineAnimationView
/*
static int limitX = 1024; // 53.13 degrees
static int limitY = 768; // 36.87 degrees
static int initValue = 0;
 */
static int animationDuration = 8; // the speed of animation
static CGFloat distence = 23;
static CGFloat animationSpeed = 0.9; // system default 1.0


- (void)drawLine {
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(100, 300)];
    [path addLineToPoint:CGPointMake(220, 300)];
    
    lineLayer.path = path.CGPath;
    lineLayer.strokeColor = [UIColor blueColor].CGColor;
    lineLayer.fillColor = [UIColor blueColor].CGColor;
    lineLayer.lineWidth = 5;
    [self.layer addSublayer:lineLayer];
    
}


- (BOOL)isLineExit {
    if (self.line_st_points == nil && self.line_ed_points == nil) {
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - public
- (void)startAnimation: (UIColor*)color {
    if ([self isLineExit] == NO) {
        [self setStraightLine];
    }
    if (self.layer.sublayers == nil) {
        [self drawLineAndStartAnimation:color];
    } else {
        [self stopAnimation];
        [self drawLineAndStartAnimation:color];
        /*for (CAShapeLayer *layer in self.layer.sublayers) {
            CGFloat offset = (arc4random() % (int)(animationDuration * 100)) + 1;
            offset /= 50;
            [self setAnimation:layer offset:offset];
        }*/
    }
}

- (void)startSinAnimation: (UIColor*)color {
    for (CAShapeLayer *layer in self.layer.sublayers) {
        CGFloat offset = (arc4random() % (int)(animationDuration * 100)) + 1;
        offset /= 50;
        
        [layer removeAllAnimations];
        [self setAnimationSin:layer offset:offset funcSelect:@"sin"];
    }
}

- (void)startReverseSinAnimation: (UIColor*)color {
    for (CAShapeLayer *layer in self.layer.sublayers) {
        CGFloat offset = (arc4random() % (int)(animationDuration * 100)) + 1;
        offset /= 50;
        
        [layer removeAllAnimations];
        [self setAnimationSin:layer offset:offset funcSelect:@"reverse"];
    }
}

- (void)stopAnimation {
    //[self removeAllLine];
    for (CAShapeLayer *layer in self.layer.sublayers) {
        [layer removeAllAnimations];
    }
    self.layer.sublayers = nil;
}

- (void)pauseAnimation {
    CFTimeInterval pausedTime;
    for (CAShapeLayer *layer in self.layer.sublayers) {
        pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
        layer.timeOffset = pausedTime;
        layer.speed = 0.0;
    }
}

- (void)resumeAnimation {
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

- (BOOL)isAnimation {
    CALayer *layer = self.layer.sublayers[0];
    if (layer.speed == 0.0) {
        return NO;
    } else {
        return YES;
    }
}

- (void)changeLineColorWhenPause: (UIColor*)color {
    [self stopAnimation];
    [self startAnimation:color];
    [self pauseAnimation];
}

- (void)changeLineColorWhenExecute: (UIColor*)color {
    for (CAShapeLayer *layer in self.layer.sublayers) {
        layer.fillColor = color.CGColor;
        layer.strokeColor = color.CGColor;
    }
}

#pragma mark - private
/*
- (void)drawScreentone {
    int pointX = initValue;
    int pointY = initValue;
    int interval = 40;
    while (pointX < limitX) {
        while (pointY < limitY) {
            [self showAPoint:CGPointMake(pointX, pointY)];
            pointY += interval;
        }
        pointY = initValue;
        pointX += interval;
    }
}

- (void)showAPoint:(CGPoint)point {
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(point.x, point.y, 5, 5);
    layer.backgroundColor = [[UIColor lightGrayColor] CGColor];
    [self.layer addSublayer:layer];
}
*/
- (void) removeAllLine {
    self.line_st_points = nil;
    self.line_ed_points = nil;
    
}

- (void) setStraightLine {
    CGFloat boundWid = self.bounds.size.width;
    CGFloat boundHei = self.bounds.size.height;
    CGFloat Diagonal = sqrtf(boundHei*boundHei + boundWid*boundWid); // sqrt(1024^2 + 768^2) 90 degrees = 1280
    //CGFloat number = 0;
    CGFloat overWidth = (Diagonal - boundWid)/2;
    CGFloat number = -overWidth;
    
    NSMutableArray *sMutArray = [[NSMutableArray alloc] init];
    NSMutableArray *eMutArray = [[NSMutableArray alloc] init];
    
    //[self setLineWithStartPoint:CGPointMake(number, boundHei / 2) endPoint:CGPointMake(Diagonal - number, boundHei / 2) lineColor:[UIColor blackColor]];
    
    while (number < Diagonal) {
        [sMutArray addObject:[NSValue valueWithCGPoint:CGPointMake(number, 124)]]; // (768/2) - 260
        [eMutArray addObject:[NSValue valueWithCGPoint:CGPointMake(number, 644)]]; // (768/2) + 260
        number += distence;
    }
    self.line_st_points = sMutArray;
    self.line_ed_points = eMutArray;
    
}

- (void)drawLineAndStartAnimation: (UIColor*)color {
    
    CGPoint stPoint, edPoint;
    NSValue *valueS, *valueE;
    
    // the straight line
    for (int j = 0; j < self.line_st_points.count; j++) {
        valueS = [self.line_st_points objectAtIndex:j];
        valueE = [self.line_ed_points objectAtIndex:j];
        stPoint = [valueS CGPointValue];
        edPoint = [valueE CGPointValue];
        [self setLineWithStartPoint:stPoint endPoint:edPoint lineColor:color];
        //[self setLineWithStartPoint:stPoint endPoint:edPoint lineColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.3]];
    }
    
}

- (void)setLineWithStartPoint:(CGPoint)stPoint endPoint:(CGPoint)edPoint lineColor:(UIColor*)color {
    
    CGFloat boundWid = self.bounds.size.width / 2;
    CGFloat boundHei = self.bounds.size.height / 2;
    double rotateDeg = atan2(boundHei, boundWid);
    // setting rotation
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DTranslate(transform, boundWid, boundHei, 0);
    transform = CATransform3DRotate(transform, -rotateDeg, 0, 0, 1);
    transform = CATransform3DTranslate(transform, -boundWid, -boundHei, 0);
    
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:stPoint];
    [path addLineToPoint:edPoint];
    lineLayer.transform = transform;
    lineLayer.path = path.CGPath;
    //lineLayer.fillColor = [UIColor clearColor].CGColor;
    //lineLayer.strokeColor = color.CGColor;
    lineLayer.strokeColor = color.CGColor;
    lineLayer.fillColor = color.CGColor;
    lineLayer.lineWidth = 5;
    lineLayer.lineCap = kCALineCapRound;
    [self.layer addSublayer:lineLayer];
    
    if (stPoint.x == edPoint.x) {
        CGFloat offset = (arc4random() % (int)(animationDuration * 100)) + 1;
        offset /= 50;
        [self setAnimation:lineLayer offset:offset];
        //[self setAnimationSin:lineLayer offset:arc4random() % 60];
    }
    
}

- (void)setAnimation:(CAShapeLayer*)layer offset:(CFTimeInterval)offsetNumber{
    layer.strokeStart = 0.5;
    layer.strokeEnd = 0.5;
    
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    animation1.fromValue = @0.5;
    animation1.toValue = @0.0;
    animation1.duration = animationDuration;
    animation1.repeatCount = INFINITY;
    animation1.autoreverses = YES;
    animation1.removedOnCompletion = NO;
    animation1.fillMode = kCAFillModeForwards;
    animation1.timeOffset = offsetNumber;
    animation1.speed = animationSpeed;
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation2.fromValue = @0.5;
    animation2.toValue = @1.0;
    animation2.duration = animationDuration;
    animation2.repeatCount = INFINITY;
    animation2.autoreverses = YES;
    animation2.removedOnCompletion = NO;
    animation2.fillMode = kCAFillModeForwards;
    animation2.timeOffset = offsetNumber;
    animation2.speed = animationSpeed;
    [layer addAnimation:animation1 forKey:@"upAnimation"];
    [layer addAnimation:animation2 forKey:@"downAnimation"];
}

- (void)setAnimationSin:(CAShapeLayer*)layer offset:(CFTimeInterval)offsetNumber funcSelect:(NSString*)func {
    // sin setting
    NSUInteger fps = 24;
    NSUInteger frameCount = (NSUInteger)animationDuration*fps;
    NSMutableArray *keytimes = [NSMutableArray arrayWithCapacity:frameCount];
    NSMutableArray *values1 = [NSMutableArray arrayWithCapacity:frameCount];
    NSMutableArray *values2 = [NSMutableArray arrayWithCapacity:frameCount];
    NSMutableArray *value = [NSMutableArray arrayWithCapacity:frameCount];
    
    // keytimes
    for (double i=0, add = (double)1/frameCount; i<=1.0; i+=add) {
        [keytimes addObject:@(i)];
    }
    
    CGFloat amp = 0.5, x, x_1, x_2, add; // amplitude
    add = M_PI/(frameCount);
    if ([func  isEqual: @"sin"]) {
        for (NSUInteger i=0; i<frameCount; i++) {
            x = amp*sin((double)i*add);
            x_1 = 0.5 - x;
            x_2 = 0.5 + x;
            [values1 addObject:@(x_1)];
            [values2 addObject:@(x_2)];
            [value addObject:@(x)];
        }
    } else { // reverse sin
        NSMutableArray *v1 = [NSMutableArray arrayWithCapacity:frameCount];
        NSMutableArray *v2 = [NSMutableArray arrayWithCapacity:frameCount];
        for (NSUInteger i=0; i<frameCount; i++) {
            x = amp*sin( -((double)i*add) );
            x_1 = - x;
            x_2 = 1.0 + x;
            [v1 addObject:@(x_1)];
            [v2 addObject:@(x_2)];
            [value addObject:@(x)];
        }
        values1 = [[[v1 reverseObjectEnumerator] allObjects] mutableCopy];
        values2= [[[v2 reverseObjectEnumerator] allObjects] mutableCopy];
    }
    layer.strokeStart = 0.5;
    layer.strokeEnd   = 0.5;
    
    CAKeyframeAnimation *animation1 = [CAKeyframeAnimation animationWithKeyPath:@"strokeStart"];
    CAKeyframeAnimation *animation2 = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    animation1.values = values1;
    animation2.values = values2;
    animation1.keyTimes = keytimes;
    animation2.keyTimes = keytimes;
    animation1.duration = animationDuration;
    animation2.duration = animationDuration;
    animation1.repeatCount = INFINITY;
    animation2.repeatCount = INFINITY;
    animation1.removedOnCompletion = NO;
    animation2.removedOnCompletion = NO;
    animation1.timeOffset = offsetNumber;
    animation2.timeOffset = offsetNumber;
    animation1.speed = animationSpeed /1.75;
    animation2.speed = animationSpeed /1.75;
    [layer addAnimation:animation1 forKey:@"upAnimation"];
    [layer addAnimation:animation2 forKey:@"downAnimation"];
    
}



@end
