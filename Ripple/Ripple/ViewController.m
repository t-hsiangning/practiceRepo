//
//  ViewController.m
//  Ripple
//
//  Created by Kaihatsu Goro on 2016/11/17.
//  Copyright © 2016年 Kaihatsu Goro. All rights reserved.
//

#import "ViewController.h"
#import "CARippleView.h"
#import "RippleLayer.h"

static NSString *rippleAnimationKey = @"rippleAnimationKey";

@interface ViewController ()

@property (weak, nonatomic) IBOutlet CARippleView *rippleView;
//@property (weak, nonatomic) RippleLayer *nLayer; // for test RippleLayer
@property BOOL isAnimation;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.rippleView startAnimation];
    self.isAnimation = YES;
    
    // double tap setting
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    doubleTapGesture.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTapGesture];
    
    // left swipe to stop
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeft];
    
    // right swipe to start
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRight];
    
    
    /* 
     // for test RippleLayer
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.9 target:self selector:@selector(timerRandShowCircle) userInfo:nil repeats:YES];
    [runLoop addTimer:timer forMode:NSDefaultRunLoopMode];*/
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doubleTap: (UIGestureRecognizer*)recognizer {
    if (self.isAnimation == YES) {
        self.isAnimation = NO;
        [self.rippleView pauseAnimation];
        //[self.rippleView stopAnimation];
    } else {
        self.isAnimation = YES;
        //[self.rippleView startAnimation];
        [self.rippleView resumeAnimation];
    }
}

- (void)swipeLeft: (UIGestureRecognizer*)recognizer { // left swipe to stop
    if (self.isAnimation == YES) {
        self.isAnimation = NO;
        [self.rippleView stopAnimation];
    }
}

- (void)swipeRight: (UIGestureRecognizer*)recognizer { // right swipe to start
    if (self.isAnimation == NO) {
        self.isAnimation = YES;
        [self.rippleView startAnimation];
    }
}



/*
 // for test RippleLayer
- (void)timerRandShowCircle {
    RippleLayer *rLayer = [RippleLayer layer];
    
    rLayer.position = [self getRandomPosition];
    [self setCircleLayer:rLayer withRadius:[self getRandomRadius]];
    [self.view.layer addSublayer:rLayer];
    [rLayer startAnimation:[self getRandomColor]];
}

- (CGPoint)getRandomPosition {
    int width = self.view.frame.size.width + 1; // for iPad is 1024
    int height = self.view.frame.size.height + 1; // for iPad is 768
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
}

- (CGFloat)getRandomRadius {
    CGFloat rRadius;
    if ( [(NSString*)[UIDevice currentDevice].model hasPrefix:@"iPad"]) {
        rRadius = (arc4random() % 150) + 50;
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

- (void)timerCheck {
    NSArray *layerArray = self.view.layer.sublayers;
    for (RippleLayer *layer in layerArray) {
        if ([layer isKindOfClass:[RippleLayer class]]) {
            if (layer.isAnimation == NO) {
                layer.hidden = YES;
                [layer removeAllAnimations];
            }
        }
    }
}*/
@end
