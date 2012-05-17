//
//  KDGoalBarPercentLayer.m
//  AppearanceTest
//
//  Created by Kevin Donnelly on 1/10/12.
//  Copyright (c) 2012 -. All rights reserved.
//

#import "KDGoalBarPercentLayer.h"

#define toRadians(x) ((x)*M_PI / 180.0)
#define toDegrees(x) ((x)*180.0 / M_PI)

@implementation KDGoalBarPercentLayer
@synthesize percent, color;

-(void)drawInContext:(CGContextRef)ctx {
    
    CGPoint center = CGPointMake(self.frame.size.width / (2), self.frame.size.height / (2));

    CGFloat delta = toRadians(360 * percent);
    
    CGFloat innerRadius = 62.5;
    CGFloat outerRadius = 87.5;
    
    if (color) {
        CGContextSetFillColorWithColor(ctx, color.CGColor);
    } else {
        CGContextSetFillColorWithColor(ctx, [UIColor colorWithRed:99/256.0 green:183/256.0 blue:70/256.0 alpha:.5].CGColor);
    }
    
    CGContextSetLineWidth(ctx, 1);
    
    CGContextSetLineCap(ctx, kCGLineCapRound);
    
    CGContextSetAllowsAntialiasing(ctx, YES);
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathAddRelativeArc(path, NULL, center.x, center.y, innerRadius, -(M_PI / 2), delta);
    CGPathAddRelativeArc(path, NULL, center.x, center.y, outerRadius, delta - (M_PI / 2), -delta);
    CGPathAddLineToPoint(path, NULL, center.x, center.y-innerRadius);
    
    CGContextAddPath(ctx, path);
    CGContextFillPath(ctx);
    
    CFRelease(path);
    
}

@end
