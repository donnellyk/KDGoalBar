//
//  SoundPlayer.h
//  TrackerApp
//
//  Created by Kevin Donnelly on 4/11/12.
//  Copyright (c) 2012 -. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SETap @"Tap"
#define SESlide @"Slide"
#define SEClick @"Click"
#define SERelease @"Release"
#define SETransition @"Transition"

@interface SoundPlayer : NSObject

+(void) soundEffect:(NSString *)sound;

@end
