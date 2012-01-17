//
//  KDGoalBar.h
//  AppearanceTest
//
//  Created by Kevin Donnelly on 1/10/12.
//  Copyright (c) 2012 -. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "KDGoalBarPercentLayer.h"

@interface KDGoalBar : UIControl {
    UIImage * bg;
    UIImage * thumb;
    UIImage * ridge;
    
    KDGoalBarPercentLayer *percentLayer;
    CALayer *thumbLayer;
    CALayer *ridgeLayer;
    
    int finalPercent;
    BOOL dragging;
    BOOL thumbTouch;
    BOOL currentAnimating;
    
    CGFloat lastAngle;
    CGFloat totalAngle;
}

@property (nonatomic) BOOL allowDragging;
@property (nonatomic) BOOL allowTap;

@property (nonatomic, strong) UILabel *percentLabel;


- (void)setPercent:(int)percent animated:(BOOL)animated;
- (void)setBarColor:(UIColor *)color;
- (void)setThumbEnabled:(BOOL)enabled;
- (BOOL)thumbEnabled;
- (void)moveThumbToPosition:(CGFloat)angle;

@end
