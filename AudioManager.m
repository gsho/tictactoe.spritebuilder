//
//  AudioManager.m
//  tictacslam
//
//  Created by Brian Schaper on 8/13/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "AudioManager.h"
#import "OALSimpleAudio.h"

@implementation AudioManager

// Use this method to play a sound effect based on the sound file passed in
- (void)playSoundEffect:(NSString *)soundFile {

  if ([[NSUserDefaults standardUserDefaults] boolForKey:@"SoundOn"]) {

    [[OALSimpleAudio sharedInstance] playEffect:soundFile];
  }
}

+ (AudioManager *)sharedAudioManager {

  // we are using the dispatch once predicate to ensure we use the same object
  // across all scenes
  static dispatch_once_t pred;
  static AudioManager *_sharedInstance;

  dispatch_once(&pred, ^{ _sharedInstance = [[self alloc] init]; });

  return _sharedInstance;
}

@end
