//
//  Settings.m
//  tictacslam
//
//  Created by Brian Schaper on 7/23/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "SettingsScene.h"

@implementation SettingsScene

- (void)play {

  CCLOG(@"SettingsScene - play button pushed");

  if ([GameManager sharedGameManager].playerPieceSelected == NO) {

    // Send user to setup screen to pick x or o piece
    CCScene *scene = [CCBReader loadAsScene:@"SetupScene"];
    [[CCDirector sharedDirector] replaceScene:scene];

  } else {

    // Send them to the main scene if they already have their piece selected
    CCScene *scene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:scene];
  }
}

- (void)scores {

  CCLOG(@"SettingsScene - reset button pushed");

  // reset all game values
  [GameManager sharedGameManager].playerPieceSelected = NO;
  [GameManager sharedGameManager].piecesPlayedX = nil;
  [GameManager sharedGameManager].piecesPlayedO = nil;

  CCScene *scene = [CCBReader loadAsScene:@"ScoresScene"];
  [[CCDirector sharedDirector] replaceScene:scene];
}

@end
