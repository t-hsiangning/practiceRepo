//
//  DrawWaveLineViewController.m
//  CAShapeLineAnimation
//
//  Created by Kaihatsu Goro on 2016/07/14.
//  Copyright © 2016年 Kaihatsu Goro. All rights reserved.
//

#import "DrawWaveLineViewController.h"
#import "LineAnimationView.h"

@interface DrawWaveLineViewController()
/*
@property NSArray* StartPoint;
@property NSArray* EndPoint;

@property NSArray* startPoint_length;
@property NSArray* endPoint_length;
*/
@property NSArray* sPoint_straight_line;
@property NSArray* ePoint_straight_line;
//@property (weak, nonatomic) IBOutlet UIView *animationView;

@property (weak, nonatomic) IBOutlet LineAnimationView *animationView;
@property (nonatomic, strong) LineAnimationView *customView;
@end

@implementation DrawWaveLineViewController

static int limitX = 1024; // 53.13 degrees
static int limitY = 768; // 36.87 degrees
//static int Diagonal = 1280; // sqrt(1024^2 + 768^2) 90 degrees
static int initValue = 0;
static int animationDuration = 8; // the speed of animation
static CGFloat distence = 15;
static CGFloat animationSpeed = 1.1; // system default 1.0
/*
static CGFloat radius(CGFloat degrees) {
    return degrees * M_PI / 180.0;
}
*/
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //[self drawScreentone];
    
    // the straight line
    //[self setStraightLine];
    
    //[self drawLine]; // draw line and set the animation
    
    //[self removeAllLine];
    
    // custom animation view class
    //[self.customView drawScreentone];
    //[self.animationView drawScreentone];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)drawLine {
    
    CGPoint stPoint, edPoint;
    NSValue *valueS, *valueE;
    
    // the straight line
    for (int j = 0; j < self.sPoint_straight_line.count; j++) {
        valueS = [self.sPoint_straight_line objectAtIndex:j];
        valueE = [self.ePoint_straight_line objectAtIndex:j];
        stPoint = [valueS CGPointValue];
        edPoint = [valueE CGPointValue];
        [self setLineWithStartPoint:stPoint endPoint:edPoint lineColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.3]];
    }
    /*
    [self setLineWithStartPoint:CGPointMake(0, 560)  endPoint:CGPointMake(208, 768)]; // 5
    [self setLineWithStartPoint:CGPointMake(0, 600)  endPoint:CGPointMake(168, 768)];
    [self setLineWithStartPoint:CGPointMake(0, 640)  endPoint:CGPointMake(128, 768)];
    [self setLineWithStartPoint:CGPointMake(0, 680)  endPoint:CGPointMake(88, 768)];
    [self setLineWithStartPoint:CGPointMake(0, 720)  endPoint:CGPointMake(48, 768)];
     */
}

- (void) removeAllLine {
    self.sPoint_straight_line = nil;
    self.ePoint_straight_line = nil;
    
    //[self.animationView.layer removeAllAnimations];
    //[self.animationView.layer removeFromSuperlayer];
}

- (void) setStraightLine {
    CGFloat boundWid = self.animationView.bounds.size.width;
    CGFloat boundHei = self.animationView.bounds.size.height;
    CGFloat Diagonal = sqrtf(boundHei*boundHei + boundWid*boundWid); // sqrt(1024^2 + 768^2) 90 degrees = 1280
    //CGFloat number = 0;
    CGFloat overWidth = (Diagonal - boundWid)/2;
    CGFloat number = -overWidth;
    
    NSMutableArray *sMutArray = [[NSMutableArray alloc] init];
    NSMutableArray *eMutArray = [[NSMutableArray alloc] init];
    while (number < Diagonal) {
        [sMutArray addObject:[NSValue valueWithCGPoint:CGPointMake(number, 124)]]; // (768/2) - 260
        [eMutArray addObject:[NSValue valueWithCGPoint:CGPointMake(number, 644)]]; // (768/2) + 260
        number += distence;
    }
    self.sPoint_straight_line = sMutArray;
    self.ePoint_straight_line = eMutArray;
    
}


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
    [self.animationView.layer addSublayer:layer];
}
/*
- (void)stopAnimation {
    [self.animationView.layer removeAllAnimations];
}
*/
- (void)setLineWithStartPoint:(CGPoint)stPoint endPoint:(CGPoint)edPoint lineColor:(UIColor*)color {
    
    CGFloat boundWid = self.animationView.bounds.size.width / 2;
    CGFloat boundHei = self.animationView.bounds.size.height / 2;
    double rotateDeg = atan2(boundHei, boundWid);
    // setting rotation
    CATransform3D transform = CATransform3DIdentity;
    //transform = CATransform3DTranslate(transform, boundWid, 0, 0);
    transform = CATransform3DTranslate(transform, boundWid, boundHei, 0);
    transform = CATransform3DRotate(transform, -rotateDeg, 0, 0, 1);
    transform = CATransform3DTranslate(transform, -boundWid, -boundHei, 0);
    //transform = CATransform3DScale(transform, 0.5, 0.5, 1.0);
    
    //transform = CATransform3DScale(transform, 1.1, 1.1, 1);
    
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:stPoint];
    [path addLineToPoint:edPoint];
    lineLayer.transform = transform;
    lineLayer.path = path.CGPath;
    lineLayer.fillColor = [UIColor clearColor].CGColor;
//    lineLayer.strokeColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.3].CGColor;
//  lineLayer.strokeColor = [UIColor blueColor].CGColor;
    lineLayer.strokeColor = color.CGColor;
    lineLayer.lineWidth = 4;
    [self.animationView.layer addSublayer:lineLayer];
    
    [self setAnimation:lineLayer offset:arc4random()];
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
    animation1.timeOffset = offsetNumber;
    animation1.speed = animationSpeed;
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation2.fromValue = @0.5;
    animation2.toValue = @1.0;
    animation2.duration = animationDuration;
    animation2.repeatCount = INFINITY;
    animation2.autoreverses = YES;
    animation2.removedOnCompletion = NO;
    animation2.timeOffset = offsetNumber;
    animation2.speed = animationSpeed;
    [layer addAnimation:animation1 forKey:@"upAnimation"];
    [layer addAnimation:animation2 forKey:@"downAnimation"];
    
}

- (IBAction)pauseButtonTouch:(id)sender { // Change
    int randSelection = arc4random() % 4;
    switch (randSelection) {
        case 0:
            self.animationView.backgroundColor = [UIColor redColor];
            break;
        case 1:
            self.animationView.backgroundColor = [UIColor cyanColor];
            break;
        case 2:
            self.animationView.backgroundColor = [UIColor yellowColor];
            break;
        case 3:
            self.animationView.backgroundColor = [UIColor lightGrayColor];
            break;
        default:
            self.animationView.backgroundColor = [UIColor clearColor];
            break;
    }
}

- (IBAction)startButtonTouch:(id)sender {
    if (self.sPoint_straight_line == nil && self.ePoint_straight_line == nil) {
        [self setStraightLine];
        [self drawLine];
    }
}

- (IBAction)stopButtonTouch:(id)sender {
    self.animationView.layer.sublayers = nil; // remove all sublayer
    [self removeAllLine];
}

@end