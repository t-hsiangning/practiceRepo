//
//  WaveAnimationView.m
//  WaveAnimation
//
//  Created by Kaihatsu Goro on 2016/07/21.
//  Copyright © 2016年 Kaihatsu Goro. All rights reserved.
//

#import "WaveAnimationView.h"

#define DEGREES_TO_RADIANS(degrees) ( (M_PI*degrees) / 180 )

@interface WaveAnimationView ()

// CADisplayLink test executing sample
@property CADisplayLink* displayLink;

@end


@implementation WaveAnimationView {
    
    CGFloat circleCount;
    
    CGFloat width;
    CGFloat height;
    
    CGFloat waveMoveSpan;
    CGFloat period;
    CGFloat offset;
    CGPoint start_point;
    CGPoint end_point;
    
    UIBezierPath *bezierPath;
    CAShapeLayer *shapeLayer;
    CADisplayLink *waveDisplayLink;
}

- (instancetype)init { // 初始化有問題所以會中斷
    if (self = [super init]) {
        self.layer.masksToBounds = YES;
        //self.backgroundColor = [UIColor clearColor];
        [self initializeVariable];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
}


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        [self initializeVariable];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        [self initializeVariable];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    //[self initializeVariable];
}

// MARK -- public
- (void)startWaveAnimationWithColor: (UIColor*)color {
    
    CGFloat duration = 10;
    CGFloat animationOffset = (arc4random() % (int)(duration * 50)) + 1; // 5 is speed
    animationOffset /= 50;
    CAKeyframeAnimation* animation = [self getFadeAnimationWithDuration:duration Offset:offset];
    
    bezierPath = [UIBezierPath bezierPath];
    shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor = color.CGColor;
    
    [self.layer addSublayer:shapeLayer];
    [shapeLayer addAnimation:animation forKey:@"fadeAnimation"];
    
    
    waveDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(drawWave:)];
    [waveDisplayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
}

- (void)stopWave {
    [waveDisplayLink invalidate];
    waveDisplayLink = nil;
}

// MARK -- private
- (void)initializeVariable {
    width = self.frame.size.width;
    height = self.frame.size.height;
    
    circleCount = 3.5;
    self.amplitude = 50;
    period = 200;
    waveMoveSpan = 5.0;
    offset = 0.0;
    self.speed = 1;
    
    start_point = CGPointMake(0, height/2);
    end_point   = CGPointMake(width, height/2);
    
}

- (void)drawWave:(CADisplayLink*)displayLink{
    
    offset += self.speed;
    
    if (offset > 360) {
        offset -= 360;
        
    } else {
        offset += self.speed;
    }
    
    bezierPath = [self getBezierPath];
    shapeLayer.path = bezierPath.CGPath;
}

- (CGFloat)getOffset {
    CGFloat tempOffset = offset;
    return tempOffset;
}

- (UIBezierPath*)getBezierPath{
    
    UIBezierPath *bPath = [UIBezierPath bezierPath];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, start_point.x, start_point.y);
    CGFloat waveBaseHeight = start_point.y;
    CGFloat waveBaseWidth  = fabs(end_point.x - start_point.x);
    CGFloat frame = circleCount * M_PI / waveBaseWidth;
    CGFloat y = 0.0f;
    
    for (float x = 0.0f; x <= waveBaseWidth; x++) {
        y = self.amplitude * sinf(frame * x - (offset * M_PI / 180)) + waveBaseHeight;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    
    CGPathAddLineToPoint(path, nil, end_point.x, height*3/4);
    CGPathAddLineToPoint(path, nil, start_point.x, height*3/4);
    CGPathCloseSubpath(path);
    
    bPath.CGPath = path;
    CGPathRelease(path);
    return bPath;
}

// MARK: -- show dot --
- (void)showAPoint:(CGPoint)point {
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(point.x, point.y, 3, 3);
    layer.backgroundColor = [[UIColor lightGrayColor] CGColor];
    [self.layer addSublayer:layer];
}

- (void)showAPointWithX:(CGFloat)x_point Y:(CGFloat)y_point {
    [self showAPoint:CGPointMake(x_point, y_point)];
}

- (void)showAPoint:(CGPoint)point withColor:(UIColor*)color {
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(point.x, point.y, 3, 3);
    layer.backgroundColor = color.CGColor;
    [self.layer addSublayer:layer];
}

- (void)showAPointWithX:(CGFloat)x_point Y:(CGFloat)y_point Color:(UIColor*)color{
    [self showAPoint:CGPointMake(x_point, y_point) withColor:color];
}



// MARK: -- animation --
- (CAKeyframeAnimation*)getFadeAnimationWithDuration:(CGFloat)duration Offset:(CGFloat)offset{
    
    // fade animation sin(x) setting
    NSUInteger fps = 24;
    NSUInteger frameCount = (NSUInteger)duration*fps;
    NSMutableArray *keytimes = [NSMutableArray arrayWithCapacity:frameCount];
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:frameCount];
    for (double i=0, add = (double)1/frameCount; i<=1.0; i+=add) {
        [keytimes addObject:@(i)];
    }
   // [keytimes addObject:@(1)];
    CGFloat amp = 0.8; // amplitude for color
    CGFloat add = M_PI/frameCount;
    for (NSUInteger i=0; i<frameCount; i++) {
        CGFloat x = amp*sin((double)i*add)+0.1;
        [values addObject:@(x)];
    }
   // [values addObject:@(0)];
    
    
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    animation.repeatCount = INFINITY;
    animation.autoreverses = NO;
    animation.values   = values; // 1.0 - 0.5 - 0.0
    animation.keyTimes = keytimes; // 0.0 - 0.5 - 0.5
    animation.duration = duration;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    return animation;
}






// CADisplayLink test executing sample
- (void)startDisplayLink {
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleDisplayLink:)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)handleDisplayLink:(CADisplayLink*)displayLink {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    // 改變 layer 的屬性
    [CATransaction commit];
}

@end
