//
//  GameOverScene.m
//  tictacslam
//
//  Created by Brian Schaper on 7/16/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "GameOverScene.h"

@implementation GameOverScene

@synthesize draw, oWins, xWins;

// init methods
#pragma mark -
#pragma mark Loading

- (void)didLoadFromCCB {

  CCLOG(@"GameOverScene - didLoadFromCCB");

  // setup things like a timer or anything else you want to start when the main

  [GameManager sharedGameManager].playerPieceSelected = NO;

  self.xWins.visible = NO;
  self.oWins.visible = NO;
  self.draw.visible = NO;

  if ([GameManager sharedGameManager].drawGame == YES) {

    self.draw.visible = YES;

  } else if ([GameManager sharedGameManager].activePlayer == playerX) {

    self.xWins.visible = YES;

  } else if ([GameManager sharedGameManager].activePlayer == playerO) {

    self.oWins.visible = YES;
  }
}

- (void)play {

  CCLOG(@"GameOverScene - play button pushed");

  // Send user to setup screen to pick x or o piece
  CCScene *scene = [CCBReader loadAsScene:@"SetupScene"];
  [[CCDirector sharedDirector] replaceScene:scene];
}

- (void)scores {

  CCLOG(@"GameOverScene - scores button pushed");

  // Send user to setup screen to pick x or o piece
  CCScene *scene = [CCBReader loadAsScene:@"ScoresScene"];
  [[CCDirector sharedDirector] replaceScene:scene];
}

- (void)settings {

  CCLOG(@"GameOverScene - settings button pushed");

  // Send user to setup screen to pick x or o piece
  CCScene *scene = [CCBReader loadAsScene:@"SettingsScene"];
  [[CCDirector sharedDirector] replaceScene:scene];
}

#pragma mark -
#pragma mark Cleanup

- (void)dealloc {
  NSLog(@"GameOverScene Dealloc");
}

@end
