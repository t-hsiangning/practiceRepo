//
//  ViewController.m
//  WaveAnimation
//
//  Created by Kaihatsu Goro on 2016/07/21.
//  Copyright © 2016年 Kaihatsu Goro. All rights reserved.
//

#import "ViewController.h"
#import "WaveAnimationView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet WaveAnimationView *waveView;
@property (weak, nonatomic) IBOutlet WaveAnimationView *waveView2;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.waveView.speed = 1.2f; // the larger, the faster
    self.waveView.amplitude = 35.0f;
    [self.waveView startWaveAnimationWithColor:[UIColor colorWithRed:92/255.0 green:191/255.0 blue:252/255.0 alpha:1.0]];//92, 191, 252
    
    self.waveView2.speed = 0.8f;
    self.waveView2.amplitude = 20.0f;
    [self.waveView2 startWaveAnimationWithColor:[UIColor greenColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
