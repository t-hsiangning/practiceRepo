//
//  DrawWaveViewController.m
//  WaveAnimation
//
//  Created by Kaihatsu Goro on 2016/07/21.
//  Copyright © 2016年 Kaihatsu Goro. All rights reserved.
//

// the view controller show the wave line by using two method
// method one: use dot to draw lines
// method two: use bezier line to draw lines (use less dot)

#import "DrawWaveViewController.h"

#define DEGREES_TO_RADIANS(degrees) ( (M_PI*degrees) / 180 )

@interface DrawWaveViewController ()

@property CGFloat width; // 1024
@property CGFloat height; // 768
@property int circleCount; // for dot

// for bezier path
@property CGFloat position;
@property CGFloat progress; // not use
@property CGFloat halfCycle;
@property CGFloat changeX;
@property CGFloat waveMoveSpan;
@property CGFloat amplitude; // 振幅
@property CGFloat period; // 週期
@property CGFloat displacement;

@end

@implementation DrawWaveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.width = self.view.bounds.size.width;
    self.height = self.view.bounds.size.height;
    
    
    
    self.position = 40;
    self.progress = 0.5;
    self.amplitude = 50.0; // for both amplitude
    self.period = 200;
    self.waveMoveSpan = 5.0;
    self.changeX = 50;
    self.displacement = 50.0;
    
    
    CGPoint st_point_1_4 = CGPointMake(0, self.height/4);
    CGPoint ed_point_1_4 = CGPointMake(self.width, self.height/4);
    CGPoint st_point_1_2 = CGPointMake(0, self.height/2);
    CGPoint ed_point_1_2 = CGPointMake(self.width, self.height/2);
    CGPoint st_point_3_4 = CGPointMake(0, self.height/4*3);
    CGPoint ed_point_3_4 = CGPointMake(self.width, self.height/4*3);
    
    
    
    
    
    //self.position = (1 - self.progress) * (self.view.frame.size.height);
    self.position = 0.0;
    
    self.halfCycle = 10.0;
    // --- orig ---
    // use bezier curve to draw the sin(curve) line
    //[self drawWaveWithStartPoint:st_point_1_2 endPoint:ed_point_1_2 lineColor:[UIColor cyanColor] plusMinus:NO isSolid:NO];
    
    self.halfCycle = 10;
    // --- test ---
    // use to automatic change y position
    //[self drawWaveWithStartPoint:st_point_1_4 endPoint:ed_point_3_4 lineColor:[UIColor redColor] plusMinus:NO isSolid:NO];
    
    
    self.circleCount = 10;
    
    // --- orig ---
    // use dot to draw the sin(curve) line
    [self drawWaveDotWithStartPoint:st_point_1_2 endPoint:ed_point_1_2 lineColor:[UIColor blueColor] plusMinus:NO isSolid:NO];
    
    self.circleCount = 10;
    // use to automatic change y position
    //[self drawWaveDotWithStartPoint:st_point_3_4 endPoint:ed_point_1_4 lineColor:[UIColor purpleColor] plusMinus:YES isSolid:YES];
    //[self drawWaveWithStartPoint:st_point_3_4 endPoint:ed_point_1_4 lineColor:[UIColor blackColor] plusMinus:YES isSolid:NO];
    self.displacement = 50;
    
    
    
    
    
    
    self.changeX = 6;
    
    // --- x displacement test ---
    //[self drawWaveDotWithStartPoint:CGPointMake(0 - self.changeX, 350) endPoint:CGPointMake(self.width - self.changeX, 350) lineColor:[UIColor blueColor] plusMinus:YES isSolid:YES];
    
    self.changeX = 100;
    self.circleCount = 6;
    // use to automatic change y position
    //[self drawWaveDotWithStartPoint:CGPointMake(0 - self.changeX, 150) endPoint:CGPointMake(self.width - self.changeX, 150) lineColor:[UIColor cyanColor] plusMinus:YES isSolid:YES];
    
    //[self lineAnimationTest:CGPointMake(0, self.height/2) endPoint:CGPointMake(500, self.height/2) move:100];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// MARK: -- bezier line to draw --
// method one: use bezier line and function to cauculate
- (void)drawWaveWithStartPoint: (CGPoint)st_point endPoint: (CGPoint)ed_point lineColor:(UIColor*)color plusMinus:(BOOL)select isSolid:(BOOL)solid {
    
    
    
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:st_point];

    CGFloat biggerToMove = 1.0f; // being double

    self.halfCycle *= biggerToMove;
    // draw wave(sin) line
    self.position = st_point.y;
    CGFloat minus = (ed_point.y - st_point.y) / (self.halfCycle*2);
    
    CGFloat tempPointX = st_point.x;
    CGFloat add_y = (ed_point.y - st_point.y) / (self.halfCycle);
    CGFloat base = add_y;
    self.period = fabs(ed_point.x * biggerToMove - st_point.x) * 2 / self.halfCycle;
    for (int i=1; i<=self.halfCycle; i++) {
        add_y = base * i;
        CGPoint end_point = [self keyPointForX:(tempPointX + self.period/2) originX:(st_point.x) changeY:add_y plusMinus:select];
        CGPoint con_point = [self keyPointForX:(tempPointX + self.period/4) originX:(st_point.x) changeY:add_y plusMinus:select];
        con_point.y -= minus; // to adjust the slope
        
        [path addQuadCurveToPoint:end_point controlPoint:con_point];
        tempPointX += self.period / 2;
        [self showAPoint:end_point withColor:[UIColor blueColor]];
        [self showAPoint:con_point withColor:[UIColor greenColor]];
        //self.amplitude *= 1.2;
    }
    self.halfCycle /= biggerToMove;
    
    if (solid == YES) { // solid
        [path addLineToPoint:CGPointMake(path.currentPoint.x, self.height)];
        [path addLineToPoint:CGPointMake(st_point.x, self.height)];
        [path closePath];
        lineLayer.fillColor = color.CGColor;
        lineLayer.strokeColor = color.CGColor;
    } else { // hollow
        lineLayer.fillColor = [UIColor clearColor].CGColor;
        lineLayer.strokeColor = color.CGColor;
    }
    
    CGFloat duration = 10;
    
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DMakeScale(0.5, 0.5, 0);
    //lineLayer.transform = transform;
    
    CGFloat offset = (arc4random() % (int)(duration * 50)) + 1; // 5 is speed
    offset /= 50;
    
    CABasicAnimation* animation1 = [self getMoveAnimationWithXMove:-self.period YMove:0 speed:duration OffSet:offset];
    
    
    CAKeyframeAnimation* animation2 = [self getFadeAnimationWithDuration:duration Offset:offset];
    
    lineLayer.path = path.CGPath;
    lineLayer.lineWidth = 5;
    //[lineLayer addAnimation:animation1 forKey:@"moveAnimation1"];
    //[lineLayer addAnimation:animation2 forKey:@"fadeAnimation1"];
    [self.view.layer addSublayer:lineLayer];
    
}

// determine the control point of curve
- (CGPoint)keyPointForX:(CGFloat)x originX:(CGFloat)originX changeY:(CGFloat)y_pos plusMinus:(BOOL)select {
    CGFloat y_point = [self calSinFromX:(x - originX) changeY:y_pos plusMinus:select];
    CGPoint point = CGPointMake(x, y_point);
    return point;
}

- (CGFloat)calSinFromX:(CGFloat)x_pos changeY:(CGFloat)y_pos plusMinus:(BOOL)select{
    CGFloat result;
    if (select == YES) { // plus
        result = self.amplitude * sin( -((2 * M_PI / self.period) * x_pos ) );
    } else { // minus
        result = self.amplitude * sin( ((2 * M_PI / self.period) * x_pos));
    }
    result = result + self.position + y_pos;
    return result;
}










// MARK: -- dot to draw line --
// method two: use dot to draw
- (void)drawWaveDotWithStartPoint: (CGPoint)st_point endPoint: (CGPoint)ed_point lineColor:(UIColor*)color plusMinus:(BOOL)select isSolid:(BOOL)solid {
    
    
    // draw line
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:st_point];
    
    CGFloat biggerToMove = 1.5; // being double
    ed_point.x *= biggerToMove;
    NSUInteger framecount = abs((int)(ed_point.x - st_point.x));
    CGFloat add_y = (ed_point.y - st_point.y) / framecount;
    CGFloat base = add_y;
    self.circleCount *= biggerToMove;
    CGFloat amp = self.amplitude, add = M_PI/(framecount)*self.circleCount, sinChange;
    
    for (NSUInteger i = 0; i<=framecount; i++) {
        
        if (select == YES) { // plus
            sinChange = amp*sin(-(double)i*add)/2;
        } else { // minus
            sinChange = amp*sin((double)i*add)/2;
        }
        
        add_y = base * i;
        [path addLineToPoint:CGPointMake(st_point.x + i, st_point.y + sinChange + add_y)];
        
    }
    self.circleCount /= biggerToMove;
    
    
    if (solid == YES) { // solid
        [path addLineToPoint:CGPointMake(path.currentPoint.x, self.height)];
        [path addLineToPoint:CGPointMake(st_point.x, self.height)];
        [path closePath];
        lineLayer.fillColor = color.CGColor;
        lineLayer.strokeColor = color.CGColor;
    } else { // hollow
        lineLayer.fillColor = [UIColor clearColor].CGColor;
        lineLayer.strokeColor = color.CGColor;
    }
    
    CGFloat duration = 5;
    
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DMakeScale(0.5, 0.5, 0);
    //lineLayer.transform = transform;
    
    CGFloat offset = (arc4random() % (int)(duration * 50)) + 1; // 5 is speed
    offset /= 50;
    
    CABasicAnimation* animation1 = [self getMoveAnimationWithXMove:-(self.width/self.circleCount)*2 YMove:0 speed:duration OffSet:offset];
    CAKeyframeAnimation* animation2 = [self getFadeAnimationWithDuration:duration Offset:offset];
    
    
    
    lineLayer.path = path.CGPath;
    lineLayer.lineWidth = 5;
    //[lineLayer addAnimation:animation1 forKey:@"moveAnimation2"];
    //[lineLayer addAnimation:animation2 forKey:@"fadeAnimation2"];
    
    [self.view.layer addSublayer:lineLayer];
    
}

// MARK: -- show dot --
- (void)showAPoint:(CGPoint)point {
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(point.x, point.y, 10, 10);
    layer.backgroundColor = [[UIColor lightGrayColor] CGColor];
    [self.view.layer addSublayer:layer];
}

- (void)showAPointWithX:(CGFloat)x_point Y:(CGFloat)y_point {
    [self showAPoint:CGPointMake(x_point, y_point)];
}

- (void)showAPoint:(CGPoint)point withColor:(UIColor*)color {
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(point.x, point.y, 10, 10);
    layer.backgroundColor = color.CGColor;
    [self.view.layer addSublayer:layer];
}

- (void)showAPointWithX:(CGFloat)x_point Y:(CGFloat)y_point Color:(UIColor*)color{
    [self showAPoint:CGPointMake(x_point, y_point) withColor:color];
}




// MARK: -- animation --
- (void)lineAnimationTest:(CGPoint)st_point endPoint:(CGPoint)ed_point move:(CGFloat)move {
    
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DMakeScale(0.25, 0.25, 0);
    
    
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:st_point];
    [path addLineToPoint:ed_point];
    
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(100, 0)];
    animation.duration = 8.0;
    animation.repeatCount = 10;
    animation.autoreverses = YES;
    
    
    
    lineLayer.path = path.CGPath;
    lineLayer.fillColor = [UIColor clearColor].CGColor;
    lineLayer.strokeColor = [UIColor purpleColor].CGColor;
    lineLayer.lineWidth = 5;
    //lineLayer.transform = transform;
    
    [lineLayer addAnimation:animation forKey:@"positionAnimation"];
    [self.view.layer addSublayer:lineLayer];
    
    [self showAPoint:ed_point withColor:[UIColor grayColor]];
    [self showAPointWithX:ed_point.x Y:ed_point.y+100 Color:[UIColor blackColor]];
    [self showAPointWithX:ed_point.x + 100 Y:ed_point.y Color:[UIColor yellowColor]];
    
}

- (CABasicAnimation*)getMoveAnimationWithXMove:(CGFloat)move_x YMove:(CGFloat)move_y speed:(CGFloat)duration OffSet:(CGFloat)offset{
    
    
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(move_x, move_y)];
    animation.duration = duration;
    animation.repeatCount = INFINITY;
    animation.autoreverses = NO;
    //animation.timeOffset = offset;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    return animation;
}

- (CAKeyframeAnimation*)getFadeAnimationWithDuration:(CGFloat)duration Offset:(CGFloat)offset{
    
    // fade animation sin(x) setting
    NSUInteger fps = 24;
    NSUInteger frameCount = (NSUInteger)duration*fps;
    NSMutableArray *keytimes = [NSMutableArray arrayWithCapacity:frameCount +1];
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:frameCount +1];
    for (double i=0, add = (double)1/frameCount; i<=1.0; i+=add) {
        [keytimes addObject:@(i)];
    }
    [keytimes addObject:@(1)];
    CGFloat amp = 0.9; // amplitude
    CGFloat add = M_PI/frameCount;
    for (NSUInteger i=0; i<frameCount; i++) {
        CGFloat x = amp*sin((double)i*add);
        [values addObject:@(x)];
    }
    [values addObject:@(0)];
    
    
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    animation.repeatCount = INFINITY;
    animation.autoreverses = NO;
    //animation.values = @[@1.0, @0.5, @0.0];
    //animation.keyTimes = @[@0.0, @0.5, @1.0];
    animation.values   = values;
    animation.keyTimes = keytimes;
    //animation.timeOffset = offset;
    animation.duration = duration;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    return animation;
}




@end
