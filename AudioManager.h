//
//  AudioManager.h
//  tictacslam
//
//  Created by Brian Schaper on 8/13/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioManager : NSObject

- (void)playSoundEffect:(NSString *)soundFile;
+ (instancetype)sharedAudioManager;

@end
