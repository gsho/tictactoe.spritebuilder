//
//  Settings.m
//  tictacslam
//
//  Created by Brian Schaper on 7/23/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "SettingsScene.h"

@implementation SettingsScene

@synthesize soundButton, musicButton;

- (void)onEnter {

  [super onEnter];

  // setup button states based on nsuserdefaults

  if ([[NSUserDefaults standardUserDefaults] boolForKey:@"MusicOn"]) {

    // set soundButton to on image using setselected

    [musicButton setSelected:NO];

  } else {

    // set soundButton to off image using setselected

    [musicButton setSelected:YES];
  }

  if ([[NSUserDefaults standardUserDefaults] boolForKey:@"SoundOn"]) {

    // set soundButton to on image using setselected

    [soundButton setSelected:NO];

  } else {

    // set soundButton to off image using setselected

    [soundButton setSelected:YES];
    CCSpriteFrame *spriteFrameOff =
        [CCSpriteFrame frameWithImageNamed:@"ccbResources/Export/off.png"];
    soundButton.contentSize = spriteFrameOff.originalSize;
  }
}

- (void)home {

  CCLOG(@"SettingsScene - play button pushed");

  [[AudioManager sharedAudioManager] playSoundEffect:@"click.wav"];

  // Send user to setup screen to pick x or o piece
  CCScene *scene = [CCBReader loadAsScene:@"PlayersScene"];
  [[CCDirector sharedDirector] replaceScene:scene];
}

- (void)scores {

  CCLOG(@"SettingsScene - scores button pushed");

  [[AudioManager sharedAudioManager] playSoundEffect:@"click.wav"];

  CCScene *scene = [CCBReader loadAsScene:@"ScoresScene"];
  [[CCDirector sharedDirector] replaceScene:scene];
}

- (void)toggleSound {

  if ([[NSUserDefaults standardUserDefaults] boolForKey:@"SoundOn"]) {

    // Reset user music default to off
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"SoundOn"];

  } else {
    // Reset user music default to on
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"SoundOn"];
  }
}

- (void)toggleMusic {

  if ([[NSUserDefaults standardUserDefaults] boolForKey:@"MusicOn"]) {
    // Turn Off Music
    [[OALSimpleAudio sharedInstance] stopBg];

    // Reset user music default to off
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"MusicOn"];

  } else {

    // Turn On Music
    [[OALSimpleAudio sharedInstance] playBg:@"background.mp3" loop:YES];

    // Reset user music default to on
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"MusicOn"];
  }
}

@end
