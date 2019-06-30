//
//  ViewController.m
//  CAShapeLineAnimation
//
//  Created by Kaihatsu Goro on 2016/07/14.
//  Copyright © 2016年 Kaihatsu Goro. All rights reserved.
//

#import "ViewController.h"
#import "LineAnimationView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet LineAnimationView *animationView;
@property int selectColor;
@property CGFloat lineR;
@property CGFloat lineG;
@property CGFloat lineB;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.selectColor = 0;
    self.lineR = 236;
    self.lineG = 236;
    self.lineB = 236;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.animationView startAnimation:[UIColor colorWithRed:self.lineR/255.0 green:self.lineG/255.0 blue:self.lineB/255.0 alpha:1.0]];
    
    // for test
    //[self.animationView drawLine];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeButtonTouchUp:(id)sender {
    int randSelection = self.selectColor % 5;
    self.selectColor += 1;
    CGFloat red, green, blue;
    switch (randSelection) {
        case 0: // black
            red   = 38;
            green = 38;
            blue  = 38;
            self.lineR = 61;
            self.lineG = 61;
            self.lineB = 61;
            break;
        case 1: // yellow
            red   = 237;
            green = 255;
            blue  = 31;
            self.lineR = 221;
            self.lineG = 235;
            self.lineB = 59;
            break;
        case 2: // pink
            red   = 255;
            green = 217;
            blue  = 220;
            self.lineR = 238;
            self.lineG = 208;
            self.lineB = 210;
            break;
        case 3: // brown
            red   = 235;
            green = 214;
            blue  = 171;
            self.lineR = 220;
            self.lineG = 204;
            self.lineB = 168;
            break;
        default: // 4 white
            red   = 255;
            green = 255;
            blue  = 255;
            self.lineR = 236;
            self.lineG = 236;
            self.lineB = 236;
            break;
    }
    
    self.animationView.backgroundColor = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0];
    
    if ([self.animationView isAnimation]) { // animation executing
        [self.animationView changeLineColorWhenExecute:[UIColor colorWithRed:self.lineR/255.0 green:self.lineG/255.0 blue:self.lineB/255.0 alpha:1.0]];
    } else { // animation pause
        [self.animationView changeLineColorWhenPause:[UIColor colorWithRed:self.lineR/255.0 green:self.lineG/255.0 blue:self.lineB/255.0 alpha:1.0]];
    }
    
}

- (IBAction)startButtonTouchUp:(id)sender {
    [self.animationView startAnimation:[UIColor colorWithRed:self.lineR/255.0 green:self.lineG/255.0 blue:self.lineB/255.0 alpha:1.0]];
}

- (IBAction)stopButtonTouchUp:(id)sender {
    [self.animationView stopAnimation];
}

- (IBAction)pauseButtonTouchUp:(id)sender {
    [self.animationView pauseAnimation];
}

- (IBAction)resumeButtonTouchUp:(id)sender {
    [self.animationView resumeAnimation];
}
- (IBAction)sinButtonTouchUp:(id)sender {
    [self.animationView startSinAnimation:[UIColor colorWithRed:self.lineR/255.0 green:self.lineG/255.0 blue:self.lineB/255.0 alpha:1.0]];
}
- (IBAction)cosButtonTouchUp:(id)sender {
    [self.animationView startReverseSinAnimation:[UIColor colorWithRed:self.lineR/255.0 green:self.lineG/255.0 blue:self.lineB/255.0 alpha:1.0]];
}

@end
