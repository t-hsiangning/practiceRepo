//
//  CARippleView.h
//  Ripple
//
//  Created by Kaihatsu Goro on 2016/11/17.
//  Copyright © 2016年 Kaihatsu Goro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CARippleView : UIView

// start ripple animation with random color
- (void)startAnimation;

// start ripple animation with defined color
- (void)startAnimationWith: (UIColor*)color;

// stop animation
- (void)stopAnimation;

// pause animation
- (void)pauseAnimation;

// resume animation
- (void)resumeAnimation;

// check is animationing or not
- (BOOL)isAnimation;

@end
