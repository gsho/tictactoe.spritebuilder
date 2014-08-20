//
//  Scores.m
//  tictacslam
//
//  Created by Brian Schaper on 7/24/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "ScoresScene.h"

@implementation ScoresScene
@synthesize xValueLabel, oValueLabel, drawsValueLabel;

- (void)didLoadFromCCB {

  // pull current high score from nsuserdefaults and assign it to
  // currentHighScore variable

  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

  int xWinsValue = (int)[defaults integerForKey:@"XWins"];

  xValueLabel.string = [NSString stringWithFormat:@"%i", xWinsValue];

  int oWinsValue = (int)[defaults integerForKey:@"OWins"];

  oValueLabel.string = [NSString stringWithFormat:@"%i", oWinsValue];

  int drawValue = (int)[defaults integerForKey:@"Draws"];

  drawsValueLabel.string = [NSString stringWithFormat:@"%i", drawValue];
}

- (void)reset {

  // remove stored values from persistent domain using bundleidentifier

  // NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
  //[[NSUserDefaults standardUserDefaults]
  // removePersistentDomainForName:appDomain];

  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSDictionary *dictionary = [defaults dictionaryRepresentation];

  for (id key in dictionary) {

    if ([key isEqual:@"XWins"] || [key isEqual:@"OWins"] ||
        [key isEqual:@"Draws"]) {
      [defaults removeObjectForKey:key];
    }

    [defaults synchronize];
  }
  // refresh score labels?
  xValueLabel.string = @"0";
  oValueLabel.string = @"0";
  drawsValueLabel.string = @"0";
}

- (void)home {

  CCLOG(@"ScoresScene - play button pushed");

  [[AudioManager sharedAudioManager] playSoundEffect:@"click.wav"];

  CCScene *scene = [CCBReader loadAsScene:@"PlayersScene"];
  [[CCDirector sharedDirector] replaceScene:scene];
}

- (void)settings {

  CCLOG(@"ScoresScene - reset button pushed");

  [[AudioManager sharedAudioManager] playSoundEffect:@"click.wav"];

  CCScene *scene = [CCBReader loadAsScene:@"SettingsScene"];
  [[CCDirector sharedDirector] replaceScene:scene];
}

@end
