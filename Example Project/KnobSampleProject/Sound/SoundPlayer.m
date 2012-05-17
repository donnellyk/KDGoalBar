//
//  SoundPlayer.m
//  TrackerApp
//
//  Created by Kevin Donnelly on 4/11/12.
//  Copyright (c) 2012 -. All rights reserved.
//

#import "SoundPlayer.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation SoundPlayer

+(void) soundEffect:(NSString *)sound {
    //  Don't have the license to upload the sound effect files to a public GitHub repo, so this doesn't actually do anything here. 
    
    /*
    NSString *type = @"mp3";
    
    SystemSoundID soundID;
    NSString *path = [[NSBundle mainBundle] pathForResource:sound ofType:type];
    NSURL *url = [NSURL fileURLWithPath:path];
    AudioServicesCreateSystemSoundID ((__bridge CFURLRef)url, &soundID);
    AudioServicesPlaySystemSound(soundID);
     */
}

@end
