//
//  KDBarGraph.h
//  AppearanceTest
//
//  Created by Kevin Donnelly on 1/19/12.
//  Copyright (c) 2012 -. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum
{
    Week,
    Year
} Mode;

@interface KDBarGraph : UIControl {
    Mode mode;
    CALayer *graphLayer;
    CALayer *barLayer;
    
    NSMutableArray *labelArray;
}

-(void)setMode:(Mode)newMode;
-(Mode)mode;
-(void)setValues:(NSArray *)values;
@end
