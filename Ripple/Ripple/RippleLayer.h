//
//  RippleLayer.h
//  CAReplicateRipple
//
//  Created by Kaihatsu Goro on 2016/07/19.
//  Copyright © 2016年 Kaihatsu Goro. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface RippleLayer : CAReplicatorLayer

@property BOOL isAnimation;

//- (void)startAnimation;
- (void)startAnimation:(UIColor*)color;



@end
