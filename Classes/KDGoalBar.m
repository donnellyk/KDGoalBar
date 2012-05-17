//
//  KDGoalBar.m
//  AppearanceTest
//
//  Created by Kevin Donnelly on 1/10/12.
//  Copyright (c) 2012 -. All rights reserved.
//

#import "KDGoalBar.h"
#import "SoundPlayer.h"

#define toRadians(x) ((x)*M_PI / 180.0)
#define toDegrees(x) ((x)*180.0 / M_PI)

#define divideNum 36 

@implementation KDGoalBar
@synthesize allowTap, allowDragging, allowSwitching, allowDecimal, percentLabel, delegate, customText, currentGoal;

#pragma Init & Setup
- (id)init
{
	if ((self = [super init]))
	{
		[self setup];
	}
    
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder]))
	{
		[self setup];
	}
    
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame]))
	{
		[self setup];
	}
    
	return self;
}


-(void)layoutSubviews {
    CGRect frame = self.frame;
    
    if ([customText length] != 0) {
        [percentLabel setText:customText];
    } else if (thumbLayer.hidden) {
        int percent = percentLayer.percent * 100;
        [percentLabel setText:[NSString stringWithFormat:@"%i%%", percent]];
    } else {
        float total = [self totalCalcuation];
        if (allowSwitching) {
            total += currentGoal;
        }
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        
        if (allowDecimal) {
            [formatter setMinimumFractionDigits:2];
            [formatter setMaximumFractionDigits:2];
        } else {
            [formatter setMinimumFractionDigits:0];
            [formatter setMaximumFractionDigits:0];
        }
        [percentLabel setText:[formatter stringFromNumber:[NSNumber numberWithFloat:total]]];
    }
    
    CGRect labelFrame = percentLabel.frame;
    labelFrame.origin.x = frame.size.width / 2 - percentLabel.frame.size.width / 2;
    labelFrame.origin.y = frame.size.height / 2 - percentLabel.frame.size.height / 2;
    percentLabel.frame = labelFrame;
    
    [super layoutSubviews];
}

-(void)setup {
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = NO;
    bg = [UIImage imageNamed:@"circle_outline"];
    bgPressed = [UIImage imageNamed:@"circle_outline_pressed"];
    
    thumb = [UIImage imageNamed:@"circle_thumb"];
    ridge = [UIImage imageNamed:@"circle_ridge"];
    
    percentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 125, 125)];
    [percentLabel setFont:[UIFont fontWithName:@"Futura-CondensedMedium" size:60]];
    [percentLabel setTextColor:[UIColor colorWithRed:89/255.0 green:89/255.0 blue:89/255.0 alpha:1.0]];
    [percentLabel setTextAlignment:UITextAlignmentCenter];
    [percentLabel setBackgroundColor:[UIColor clearColor]];
    percentLabel.adjustsFontSizeToFitWidth = YES;
    percentLabel.minimumFontSize = 10;
    
    [self addSubview:percentLabel];
    
    thumbLayer = [CALayer layer];
    thumbLayer.contentsScale = [UIScreen mainScreen].scale;
    thumbLayer.contents = (id) thumb.CGImage;
    thumbLayer.frame = CGRectMake(self.frame.size.width / 2 - thumb.size.width/2, 0, thumb.size.width, thumb.size.height);
    thumbLayer.hidden = YES;

    ridgeLayer = [CALayer layer];
    ridgeLayer.contentsScale = [UIScreen mainScreen].scale;
    ridgeLayer.contents = (id)ridge.CGImage;
    ridgeLayer.frame = CGRectMake(0, 0, ridge.size.width, ridge.size.height);
        
    [thumbLayer addSublayer:ridgeLayer];
    
    imageLayer = [CALayer layer];
    imageLayer.contentsScale = [UIScreen mainScreen].scale;
    imageLayer.contents = (id) bg.CGImage;
    imageLayer.frame = CGRectMake(0, 0, bg.size.width, bg.size.height);
    
    percentLayer = [KDGoalBarPercentLayer layer];
    percentLayer.contentsScale = [UIScreen mainScreen].scale;
    percentLayer.percent = 0;
    percentLayer.frame = self.bounds;
    percentLayer.masksToBounds = NO;
    [percentLayer setNeedsDisplay];
    
    [self.layer addSublayer:percentLayer];
    [self.layer addSublayer:imageLayer];
    [imageLayer removeAnimationForKey:@"frame"];
    [self.layer addSublayer:thumbLayer];
    
    dragging = NO;
    currentAnimating = NO;
    
    allowTap = YES;
    allowDragging = YES;
    
    tappableRect = CGRectMake(50, 50, 127, 127);
}


#pragma mark - Touch Events
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint thisPoint = [[touches anyObject] locationInView:self];

    if (CGRectContainsPoint(tappableRect, thisPoint) && allowSwitching) {
        switchModes = YES;
        [CATransaction begin];
        [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
        imageLayer.contents = (id)bgPressed.CGImage;
        [CATransaction commit];
    } else if (allowTap && thumbLayer.hidden) {        
        CGFloat adjustedAngle = toDegrees([self angleBetweenCenterAndPoint:thisPoint]);

        finalPercent = adjustedAngle / 360 * 100;
        int oldPercent = percentLayer.percent * 100;
        

        if (!currentAnimating) {
            [self performSelector:@selector(delayedDraw:) withObject:[NSNumber numberWithInt:oldPercent] afterDelay:.001];
        }
    } else if (CGRectContainsPoint(thumbLayer.frame, thisPoint)) {
        thumbTouch = YES;
        lastAngle = [self angleBetweenCenterAndPoint:thisPoint];
    } 
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint thisPoint = [[touches anyObject] locationInView:self];

    if (allowDragging && thumbLayer.hidden) {
        dragging = YES;

        CGFloat adjustedAngle = toDegrees([self angleBetweenCenterAndPoint:thisPoint]);

        percentLayer.percent = adjustedAngle / 360.0;
        
        [self setNeedsLayout];
        [percentLayer setNeedsDisplay];
    } else if (!thumbLayer.hidden && thumbTouch) {
        CGFloat delta = [self angleBetweenCenterAndPoint:thisPoint] - lastAngle;
        
        if (fabsf(delta) > (2*M_PI)-fabsf(delta)) {
            BOOL greaterThanZero = (delta > 0);
            delta = (2*M_PI)-fabsf(delta);
            if (greaterThanZero) {
                delta = -1 * delta;
            }
        }
        totalAngle += delta;
        lastAngle = [self angleBetweenCenterAndPoint:thisPoint];
                
        [self moveThumbToPosition:[self angleBetweenCenterAndPoint:thisPoint]];
        [self setNeedsLayout];

    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    dragging = NO;
    imageLayer.contents = (id)bg.CGImage;
    if (switchModes) {
        switchModes = NO;
        [self setThumbEnabled:!self.thumbEnabled];
        [self setCustomText:@""];
        [SoundPlayer soundEffect:SETap];
    } else if (!thumbLayer.hidden) {
        thumbTouch = NO;
        if (allowSwitching) {
            [self setThumbEnabled:!self.thumbEnabled];
            [self setCustomText:@""];
            [self.delegate valueCommitted:[NSNumber numberWithFloat:[self totalCalcuation]+currentGoal] fromControl:self];
            totalAngle = 0;
        } else if (!currentAnimating) {
            [self.delegate newValue:[NSNumber numberWithFloat:[self totalCalcuation]] fromControl:self];
            maxTotal = [self totalCalcuation];
            [self animateThumbToZero];
            if (totalAngle) {
                [SoundPlayer soundEffect:SERelease];
            }
        }
        
        
    }
}

- (BOOL)thumbHitTest:(CGPoint)point {
    return CGRectContainsPoint(thumbLayer.frame, point) && !thumbLayer.hidden;
}

#pragma mark - Drawing/Animation methods
-(void)delayedDraw:(NSNumber *)newPercentage {
    currentAnimating = YES;
    int perc = [newPercentage intValue];
    if (perc < finalPercent) {
        perc++;
    } else {
        perc--;
    }
    percentLayer.percent = perc / 100.0;
    [self setNeedsLayout];
    [percentLayer setNeedsDisplay];
    
    [self moveThumbToPosition:perc/100.0 * (2 * M_PI)];
    
    if (perc != finalPercent && !dragging) {
        [self performSelector:@selector(delayedDraw:) withObject:[NSNumber numberWithInt:perc] afterDelay:.001];
    } else {
        currentAnimating = NO;
    }
}

- (void)animateThumbToZero {
    currentAnimating = YES;
    BOOL continueAnimation = NO;
    
    if (totalAngle < .2 && totalAngle > -.2) {
        totalAngle = 0;
    } else if (totalAngle > 0) {
        totalAngle -= 10*M_PI/180;
        
        totalAngle = MAX(0, totalAngle);
        
        continueAnimation = (totalAngle > 0);
    } else if (totalAngle < 0) {
        totalAngle += 10*M_PI/180;
        
        totalAngle = MIN(0, totalAngle);
        
        continueAnimation = (totalAngle < 0);
    }
    
    [self moveThumbToPosition:totalAngle];
    [self.delegate newValue:[NSNumber numberWithFloat:(maxTotal - [self totalCalcuation])] fromControl:self];    
    [self setNeedsLayout];
    
    if (continueAnimation && !thumbTouch) {
        [self performSelector:@selector(animateThumbToZero) withObject:nil afterDelay:.01];
    } else if (!thumbTouch) {
        [self moveThumbToPosition:0];
        totalAngle = 0;
        currentAnimating = NO;
        if (maxTotal != 0) { 
            [self.delegate valueCommitted:[NSNumber numberWithFloat:maxTotal] fromControl:self];
        }
    } else {
        currentAnimating = NO;
        if (maxTotal != 0) { 
            [self.delegate valueCommitted:[NSNumber numberWithFloat:maxTotal] fromControl:self];
        }
    }
}

- (void)moveThumbToPosition:(CGFloat)angle {
    CGRect rect = thumbLayer.frame;
    CGPoint center = CGPointMake(self.bounds.size.width/2.0f, self.bounds.size.height/2.0f);
    angle -= (M_PI/2);
    
    rect.origin.x = center.x + 75 * cosf(angle) - (rect.size.width/2);
    rect.origin.y = center.y + 75 * sinf(angle) - (rect.size.height/2);
    
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    
    thumbLayer.frame = rect;
    
    [CATransaction commit];
}

-(float)bailOutAnimation {
    if (currentAnimating && !thumbLayer.hidden) {
        return maxTotal;
    }
    return 0;
}

#pragma mark - Math Helper methods
-(CGFloat)angleBetweenCenterAndPoint:(CGPoint)point {
    
    CGPoint center = CGPointMake(self.bounds.size.width/2.0f, self.bounds.size.height/2.0f);
    CGFloat origAngle = atan2f(center.y - point.y, point.x - center.x);

    //Translate to Unit circle
    if (origAngle > 0) {
        origAngle = (M_PI - origAngle) + M_PI;
    } else {
        origAngle = fabsf(origAngle);
    }
    
    //Rotating so "origin" is at "due north/Noon", I need to stop mixing metaphors
    origAngle = fmodf(origAngle+(M_PI/2), 2*M_PI);

    return origAngle;
}

-(float)totalCalcuation {
    float total;
    if (totalAngle >= -(2*M_PI/180) && totalAngle <= (2*M_PI/180)) {
        total = 0;
    } else if (totalAngle < 0) {
        total = floorf(toDegrees(totalAngle)/divideNum);
    } else {
        total = ceilf(toDegrees(totalAngle)/divideNum);
    }
    
    if (allowDecimal) {
        total = total / 4.0;
    } else {
        if (abs(total) > 100) {
            int remainder = abs(total) - 100;
            if (total < 0) {
                remainder *= -1;
            }
            total -= remainder;
            total += 25 * remainder;
        }
    }
    
    if (total != lastValue && !currentAnimating) {
        [SoundPlayer soundEffect:SEClick];
    }
    
    lastValue = total;
    return  total;
}

#pragma mark - Custom Getters/Setters
- (void)setPercent:(int)percent animated:(BOOL)animated {
    if (animated) {
        finalPercent = MIN(100, MAX(0, percent));
        int oldPercent = percentLayer.percent * 100;
        
        [self performSelector:@selector(delayedDraw:) withObject:[NSNumber numberWithInt:oldPercent] afterDelay:.001];
    } else {
        CGFloat floatPercent = percent / 100.0;
        floatPercent = MIN(1, MAX(0, floatPercent));
        
        percentLayer.percent = floatPercent;
        [self setNeedsLayout];
        [percentLayer setNeedsDisplay];
        
        [self moveThumbToPosition:floatPercent * (2 * M_PI) - (M_PI/2)];
    }
}

- (void)setBarColor:(UIColor *)color {
    percentLayer.color = color;
    [percentLayer setNeedsDisplay];
}

- (void)setThumbEnabled:(BOOL)enabled {
    [self moveThumbToPosition:0];
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    thumbLayer.hidden = !enabled;
    percentLayer.hidden = enabled;
    [CATransaction commit];
    
    [self setNeedsLayout];

}

- (void)setCustomText:(NSString *)string{
    customText = string;
    
    if ([customText length] == 0) {
        [percentLabel setFont:[UIFont fontWithName:@"Futura-CondensedMedium" size:60]];
        percentLabel.numberOfLines = 1;
    } else {
        [percentLabel setFont:[UIFont fontWithName:@"Futura-CondensedMedium" size:30]];
        percentLabel.numberOfLines = 0;
    }
    [self setNeedsLayout];
}

- (BOOL)thumbEnabled {
    return !thumbLayer.hidden;
}

- (void)displayChartMode {
    imageLayer.contents = (id)bg.CGImage;
    if (!thumbLayer.hidden && allowSwitching) {
        [self setThumbEnabled:NO];
        [self setCustomText:@""];
    }
}

@end
