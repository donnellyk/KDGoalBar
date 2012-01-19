//
//  KDBarGraph.m
//  AppearanceTest
//
//  Created by Kevin Donnelly on 1/19/12.
//  Copyright (c) 2012 -. All rights reserved.
//

#import "KDBarGraph.h"

#define yearMargin 7
#define weekMargin 12
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
    
    CGPoint nextOrig = CGPointMake(0, 0);
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
    
    for (int i = 0; i < numBars; i++) {
        nextOrig.x += margin;
        
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
    
    CGPoint nextOrig = CGPointMake(0, 0);
    UIImage *barBackground;
    int numBars;
    int margin;
    UIFont *labelFont;
    
    if (mode == Week) {
        numBars = 7;
        barBackground = [UIImage imageNamed:@"graph_week"];
        margin = weekMargin;
        labelFont = [UIFont fontWithName:@"Futura-CondensedMedium" size:16];
    } else {
        numBars = 12;
        barBackground = [UIImage imageNamed:@"graph_year"];
        margin = yearMargin;
        labelFont = [UIFont fontWithName:@"Futura-CondensedMedium" size:14];
    }
    
    [labelArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [labelArray removeAllObjects];
    
    for (int i = 0; i < numBars; i++) {
        nextOrig.x += margin;
        
        CGFloat percentFull = [[values objectAtIndex:i] floatValue] / largest;
        
        CALayer *bar = [CALayer layer];
        bar.backgroundColor = [UIColor colorWithRed:99/256.0 green:183/256.0 blue:70/256.0 alpha:.5].CGColor;
        bar.cornerRadius = 5;
        
        CGRect frame;
        frame.size.width = barBackground.size.width;
        frame.size.height = barBackground.size.height * percentFull;
        frame.origin.x = nextOrig.x;
        frame.origin.y = barBackground.size.height - frame.size.height;
        bar.frame = frame;
        
        [barLayer addSublayer:bar];
                
        UILabel *label = [[UILabel alloc] init];
        
        label.textColor = [UIColor colorWithRed:.18 green:.18 blue:.18 alpha:1.0];
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
