//
//  NewSplitViewController.m
//  CAReplicateRipple
//
//  Created by Kaihatsu Goro on 2017/01/27.
//  Copyright © 2017年 Kaihatsu Goro. All rights reserved.
//

#import "NewSplitViewController.h"
#import "RippleLayer.h"
@interface NewSplitViewController ()

@property (weak, nonatomic) IBOutlet UILabel *displayLabel;

@property int start_stop;

@end

@implementation NewSplitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view setMultipleTouchEnabled:YES];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.9 target:self selector:@selector(timerRandShowCircle) userInfo:nil repeats:YES];
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:timer forMode:NSDefaultRunLoopMode];
    self.start_stop = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
/*
- (IBAction)touchGesture:(UITapGestureRecognizer *)sender {
    self.displayLabel.hidden = YES;
    CGPoint touchPoint = [sender locationInView:self.view];
    [self showTheCircleWithPos:touchPoint.x yPos:touchPoint.y];
}
*/
- (void)timerRandShowCircle {
    int width = self.view.frame.size.width + 1; // for iPad is 1024
    int height = self.view.frame.size.height + 1; // for iPad is 768
    int x_pos, y_pos;
    srand48(time(0));
    x_pos = arc4random() % width;
    y_pos = arc4random() % height;
    [self showTheCircleWithPos:x_pos yPos:y_pos];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint touchPoint;
    for (UITouch *touch in touches) {
        touchPoint = [touch locationInView:self.view];
        [self showTheCircleWithPos:touchPoint.x yPos:touchPoint.y];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint touchPoint;
    NSLog(@"count = %lu", (unsigned long)touches.count);
    for (UITouch *touch in touches) {
        touchPoint = [touch locationInView:self.view];
        [self showTheCircleWithPos:touchPoint.x yPos:touchPoint.y];
    }
}

- (void)showTheCircleWithPos:(CGFloat)x_pos yPos:(CGFloat)y_pos{
    CGFloat rRadius;
    if ( [(NSString*)[UIDevice currentDevice].model hasPrefix:@"iPad"]) {
        rRadius = (arc4random() % 150) + 50;
    } else {
        rRadius = (arc4random() % 100) + 25;
    }
    CGFloat red   = arc4random() % 255;
    CGFloat blue  = arc4random() % 255;
    CGFloat green = arc4random() % 255;
    RippleLayer *touchLayer = [RippleLayer layer];
    [self.view.layer addSublayer:touchLayer];
    touchLayer.position = CGPointMake(x_pos, y_pos);
    [touchLayer setDelayTime:0];
    [touchLayer setCircleColor:[UIColor colorWithRed:red/255 green:green/255 blue:blue/255 alpha:1]];
    [touchLayer setRippleRepeatCount:1]; // ok
    [touchLayer setRadius:rRadius];
    [touchLayer startAnimation];
    
}

- (void)startRippleAnimation {
    
}

- (void)stopRippleAnimation {
    for (CALayer *layer in self.view.layer.sublayers) {
        [layer removeAllAnimations];
    }
    self.view.layer.sublayers = nil;
}

- (void)timerShowLayer {
    NSArray *layerArray = self.view.layer.sublayers;
    NSMutableArray *mutLayerArray;
    int count = 0;
    int totalCount = 0;
    NSLog(@"Total count : %lu", (unsigned long)layerArray.count);
    for (RippleLayer *layer in layerArray) {
        if ([layer isKindOfClass:[RippleLayer class]]) {
            totalCount++;
            if (layer.isAnimation == YES) {
                NSLog(@"%i : YES", count);
                count++;
                [mutLayerArray addObject:layer];
            } else {
                [layer removeAllAnimations];
            }
        } else {
            [mutLayerArray addObject:layer];
        }
    }
    NSLog(@"Ripple count: %i", totalCount);
    self.view.layer.sublayers = nil;
    for (CALayer* layer in mutLayerArray) {
        [self.view.layer addSublayer:layer];
    }
}
@end
