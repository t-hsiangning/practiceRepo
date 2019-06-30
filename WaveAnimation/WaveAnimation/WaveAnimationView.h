//
//  WaveAnimationView.h
//  WaveAnimation
//
//  Created by Kaihatsu Goro on 2016/07/21.
//  Copyright © 2016年 Kaihatsu Goro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaveAnimationView : UIView

@property (nonatomic, assign) CGFloat speed;

@property (nonatomic, assign) CGFloat amplitude;

@property (nonatomic, assign) UIColor* waveColor;

- (void)startWaveAnimationWithColor: (UIColor*)color;

@end
