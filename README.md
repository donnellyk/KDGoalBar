This control was born out of the heady days of iOS 5 & 6. Needless to say, the iOS and design communities have moved on. Similar, better controls can be found [here](https://www.cocoacontrols.com/search?utf8=✓&q=circular).

I'm leaving the files available because I believe there is something to be learned from every piece of code, even the bad ones that make tons of mistakes (Did I really use an NSTimer for an animation?! I'm sorry! I didn't know any better!)


KDGoalBar
=========

Simple circular progress bar &amp; bar chart.

The project comes with a fully functional example using Storyboards.

To add a Progress Bar programatically to an existing view, the following code assumes you are drawing the progress bars on the main view of your root view controller, which is called ViewController.

First, make sure to add all the required files:
* SoundPlayer.(h/m)
* KDBarGraph.(h/m)
* KDGoalBar.(h/m)
* KDGoalBarPercentLayer.(h/m)
* All PNG files contained in the "images" folder

The following frameworks are also required:
* QuartzCore
* AudioToolbox
* CoreGraphics

Your header file, ViewController.h:
```objective-c
#import <UIKit/UIKit.h>
#import "KDGoalBar.h"

@interface ViewController : UIViewController {
    KDGoalBar *percentGoalBar;
    KDGoalBar *thumbGoalBar;
}

@end
```

Your implementation file, should look like this:
```objective-c

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad
{
    // Frame coordinates are arbitrary to make this code example shorter
    // You could use "self.view.frame.size" to place them in the right position
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
