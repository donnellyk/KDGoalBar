//
//  ViewController.m
//  KnobSampleProject
//
//  Created by Kevin Donnelly on 5/17/12.
//  Copyright (c) 2012 -. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize firstGoalBar, secondGoalBar;

- (void)viewDidLoad
{
    [super viewDidLoad];
	[firstGoalBar setAllowDragging:YES];
    [firstGoalBar setAllowSwitching:NO];
    [firstGoalBar setPercent:68 animated:NO];
    
    [secondGoalBar setThumbEnabled:YES];
    [secondGoalBar setAllowSwitching:NO];
}

- (void)viewDidUnload
{
    [self setSecondGoalBar:nil];
    [self setFirstGoalBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
