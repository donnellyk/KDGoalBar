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

@protocol KDGoalBarDelegate <NSObject>

-(void)newValue:(NSNumber*)number fromControl:(id)control;
-(void)valueCommitted:(NSNumber*)number fromControl:(id)control;

@end

@interface KDGoalBar : UIControl {
    UIImage * bg;
    UIImage * bgPressed;
    UIImage * thumb;
    UIImage * ridge;
    
    KDGoalBarPercentLayer *percentLayer;
    CALayer *imageLayer;
    CALayer *thumbLayer;
    CALayer *ridgeLayer;
    
    int finalPercent;
    BOOL dragging;
    BOOL thumbTouch;
    BOOL currentAnimating;
    
    CGFloat lastAngle;
    float maxTotal;
    CGFloat totalAngle;
    
    float lastValue;
    
    CGRect tappableRect;
    BOOL switchModes;
    
}

@property (nonatomic) BOOL allowDragging;
@property (nonatomic) BOOL allowTap;
@property (nonatomic) BOOL allowSwitching;
@property (nonatomic) BOOL allowDecimal;
@property (nonatomic) int currentGoal;
@property (nonatomic, assign) id<KDGoalBarDelegate> delegate;
@property (nonatomic, strong) UILabel *percentLabel;
@property (nonatomic, strong) NSString *customText;

- (void)setPercent:(int)percent animated:(BOOL)animated;
- (void)setBarColor:(UIColor *)color;
- (void)setThumbEnabled:(BOOL)enabled;
- (BOOL)thumbEnabled;
- (void)moveThumbToPosition:(CGFloat)angle;
- (float)bailOutAnimation;
- (BOOL)thumbHitTest:(CGPoint)point;
- (void)displayChartMode;

@end
