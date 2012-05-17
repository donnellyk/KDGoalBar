//
//  KDBarGraph.m
//  AppearanceTest
//
//  Created by Kevin Donnelly on 1/19/12.
//  Copyright (c) 2012 -. All rights reserved.
//

#import "KDBarGraph.h"

#define yearMargin 13
#define weekMargin 24
#define stdWidth 320
#define stdHeight 170

@interface KDBarGraph()

- (void)setup;

@end

@implementation KDBarGraph

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

- (void)setup {
    self.backgroundColor = [UIColor clearColor];
    
    CGRect frame = self.frame;
    frame.size.width = stdWidth;
    frame.size.height = stdHeight;
    self.frame = frame;
    
    labelArray = [[NSMutableArray alloc] init];
}

-(void)setMode:(Mode)newMode {
    mode = newMode;
    
    [graphLayer removeFromSuperlayer];
    graphLayer = [CALayer layer];
    
    
    UIImage *barBackground;
    int numBars;
    int margin; 
    
    if (mode == Week) {
        numBars = 7;
        barBackground = [UIImage imageNamed:@"graph_week"];
        margin = weekMargin;
    } else {
        numBars = 12;
        barBackground = [UIImage imageNamed:@"graph_year"];
        margin = yearMargin;
    }
    
    CGPoint nextOrig = CGPointMake(10, 0);
    
    for (int i = 0; i < numBars; i++) {
        
        CALayer *barImage = [CALayer layer];
        barImage.contentsScale = [[UIScreen mainScreen] scale];
        
        barImage.contents = (id)barBackground.CGImage;
        barImage.frame = CGRectMake(nextOrig.x, nextOrig.y, barBackground.size.width, barBackground.size.height);
        
        [graphLayer addSublayer:barImage];
        
        nextOrig.x += barImage.frame.size.width + margin;
    }
    
    [self.layer addSublayer:graphLayer];
    
}

-(Mode)mode {
    return mode;
}

-(void)setValues:(NSArray *)values {
    CGFloat largest = 0;
    
    [barLayer removeFromSuperlayer];
    barLayer = [CALayer layer];
    
    for (NSNumber *value in values) {
        if (largest < [value floatValue]) {
            largest = [value floatValue];
        }
    }
    
    if (largest == 0) {
        return;
    }
    
    UIImage *barBackground;
    int numBars;
    int margin;
    int cornerRadius;
    UIFont *labelFont;
    
    if (mode == Week) {
        numBars = 7;
        barBackground = [UIImage imageNamed:@"graph_week"];
        margin = weekMargin;
        labelFont = [UIFont fontWithName:@"Futura-CondensedMedium" size:16];
        cornerRadius = 3;
    } else {
        numBars = 12;
        barBackground = [UIImage imageNamed:@"graph_year"];
        margin = yearMargin;
        labelFont = [UIFont fontWithName:@"Futura-CondensedMedium" size:14];
        cornerRadius = 5;
    }
    
    [labelArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [labelArray removeAllObjects];
    
    CGPoint nextOrig = CGPointMake(10, 0);

    
    for (int i = 0; i < numBars; i++) {        
        CGFloat percentFull = [[values objectAtIndex:i] floatValue] / largest;
        
        CALayer *bar = [CALayer layer];
        bar.backgroundColor = [UIColor colorWithRed:99/256.0 green:183/256.0 blue:70/256.0 alpha:.5].CGColor;
        bar.cornerRadius = cornerRadius;
        
        CGRect frame;
        frame.size.width = barBackground.size.width;
        frame.size.height = MAX(barBackground.size.height * percentFull-1, 0);
        frame.origin.x = nextOrig.x;
        frame.origin.y = barBackground.size.height - frame.size.height-1;
        bar.frame = frame;
        
        [barLayer addSublayer:bar];
                
        UILabel *label = [[UILabel alloc] init];
        
        label.textColor = [UIColor colorWithRed:.18 green:.18 blue:.18 alpha:1.0];
        label.backgroundColor = [UIColor clearColor];
        label.font = labelFont;
        label.textAlignment = UITextAlignmentCenter;
        label.text = [NSString stringWithFormat:@"%i", [[values objectAtIndex:i] intValue]];
        [label sizeToFit];
        
        label.frame = CGRectMake(nextOrig.x + frame.size.width/2 - label.frame.size.width/2, 150, label.frame.size.width,  label.frame.size.height);
        
        [labelArray addObject:label];
        [self addSubview:label];
        
        nextOrig.x += barBackground.size.width + margin;

    }
    
    [self.layer addSublayer:barLayer];
    [graphLayer removeFromSuperlayer];
    [self.layer addSublayer:graphLayer];
    
}

@end
