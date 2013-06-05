KDGoalBar
=========

Simple circular progress bar &amp; bar chart.

The project comes with a fully functional example using Storyboards. To add a circular progress bar programatically to an existing view, do the following:

Assuming your drawing the progress bars on the main view of your root view controller called ViewController:


Your header file, ViewController.h:
```c++
#import <UIKit/UIKit.h>
#import "KDGoalBar.h"

@interface ViewController : UIViewController {
    KDGoalBar *percentGoalBar;
    KDGoalBar *thumbGoalBar;
}

@end
```

Your implementation file, should look like this:
```c++

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad
{
    // Frame coordinates are arbitrary to make the example shorter
    CGRect goalBarFrame = CGRectMake(80, 10, 177, 177);
    KDGoalBar *gb = [[KDGoalBar alloc] initWithFrame:goalBarFrame];
    percentGoalBar = gb;
    [percentGoalBar setAllowDragging:YES];
    [percentGoalBar setAllowSwitching:NO];
    [percentGoalBar setPercent:74 animated:YES];
    [self.view addSubview:percentGoalBar];
    
    goalBarFrame = CGRectMake(80, 210, 177, 177);
    gb = [[KDGoalBar alloc] initWithFrame:goalBarFrame];
    thumbGoalBar = gb;
    [thumbGoalBar setThumbEnabled:YES];
    [thumbGoalBar setAllowSwitching:NO];
    [self.view addSubview:thumbGoalBar];
}


- (void)viewDidUnload
{
    percentGoalBar = nil;
    thumbGoalBar = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

@end
```
