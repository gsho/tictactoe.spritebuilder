//
//  GameOver.m
//  tictacslam
//
//  Created by Brian Schaper on 7/16/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "GameOver.h"

@implementation GameOver

@synthesize youWin, youLose;

// init methods
#pragma mark -
#pragma mark Loading

- (void)didLoadFromCCB {

  CCLOG(@"didLoadFromCCB GameOver Scene");

  // setup things like a timer or anything else you want to start when the main

  [GameManager sharedGameManager].userPieceSelected = NO;

  self.youLose.visible = NO;
  self.youWin.visible = NO;

  [GameManager sharedGameManager].piecesPlayed1 = nil;
  [GameManager sharedGameManager].piecesPlayed2 = nil;

  if ([GameManager sharedGameManager].myTurn == NO) {

    // you lose
    self.youLose.visible = YES;

  } else if ([GameManager sharedGameManager].myTurn == YES) {
    // you win
    self.youWin.visible = YES;
  }
}

// reporting game data to server

// clean up items

- (void)play {

  CCLOG(@"play button pushed");

  // Send user to setup screen to pick x or o piece
  CCScene *scene = [CCBReader loadAsScene:@"Setup"];
  [[CCDirector sharedDirector] replaceScene:scene];
}

- (void)scores {

  CCLOG(@"scores button pushed");

  // Send user to setup screen to pick x or o piece
  CCScene *scene = [CCBReader loadAsScene:@"Scores"];
  [[CCDirector sharedDirector] replaceScene:scene];
}

- (void)settings {

  CCLOG(@"settings button pushed");

  // Send user to setup screen to pick x or o piece
  CCScene *scene = [CCBReader loadAsScene:@"Settings"];
  [[CCDirector sharedDirector] replaceScene:scene];
}

@end
