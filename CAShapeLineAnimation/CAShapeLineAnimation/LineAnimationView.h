//
//  LineAnimationView.h
//  CAShapeLineAnimation
//
//  Created by Kaihatsu Goro on 2016/07/19.
//  Copyright © 2016年 Kaihatsu Goro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LineAnimationView : UIView

// draw the Screentone
//- (void)drawScreentone;

// start animation
- (void)startAnimation: (UIColor*)color;

// start animation with sin
- (void)startSinAnimation: (UIColor*)color;

// start animation with reverse sin
- (void)startReverseSinAnimation: (UIColor*)color;

// stop animation
- (void)stopAnimation;

// pause animation
- (void)pauseAnimation;

// resume animation
- (void)resumeAnimation;

// change line color
- (void)changeLineColorWhenPause: (UIColor*)color;
- (void)changeLineColorWhenExecute: (UIColor*)color;

// check is animationing or not
- (BOOL)isAnimation;


// for test
- (void)drawLine;
@end
