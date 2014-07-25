//
//  Settings.m
//  tictacslam
//
//  Created by Brian Schaper on 7/23/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "Settings.h"

@implementation Settings

- (void)play {

  CCLOG(@"play button pushed");

  if ([GameManager sharedGameManager].userPieceSelected == NO) {

    // Send user to setup screen to pick x or o piece
    CCScene *scene = [CCBReader loadAsScene:@"Setup"];
    [[CCDirector sharedDirector] replaceScene:scene];

  } else {

    // Send them to the main scene if they already have their piece selected
    CCScene *scene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:scene];
  }
}

- (void)scores {

  CCLOG(@"reset button pushed");

  // reset all game values
  [GameManager sharedGameManager].userPieceSelected = NO;
  [GameManager sharedGameManager].piecesPlayed1 = nil;
  [GameManager sharedGameManager].piecesPlayed2 = nil;

  CCScene *scene = [CCBReader loadAsScene:@"Scores"];
  [[CCDirector sharedDirector] replaceScene:scene];
}

@end
