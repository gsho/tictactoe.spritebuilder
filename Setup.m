//
//  Setup.m
//  tictacslam
//
//  Created by Brian Schaper on 7/22/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "Setup.h"

@implementation Setup

// process piece selection on user button touch

#pragma mark -
#pragma mark Main Scene Button Methods

- (void)oButton {

  CCLOG(@"oButton button pushed");

  [GameManager sharedGameManager].activeUser = 2;
  [GameManager sharedGameManager].userPieceSelected = YES;

  // Send user to setup screen to pick x or o piece
  CCScene *scene = [CCBReader loadAsScene:@"MainScene"];
  [[CCDirector sharedDirector] replaceScene:scene];
}

- (void)xButton {

  CCLOG(@"xButton button pushed");

  [GameManager sharedGameManager].activeUser = 1;
  [GameManager sharedGameManager].userPieceSelected = YES;

  // Send user to setup screen to pick x or o piece
  CCScene *scene = [CCBReader loadAsScene:@"MainScene"];
  [[CCDirector sharedDirector] replaceScene:scene];
}

@end
