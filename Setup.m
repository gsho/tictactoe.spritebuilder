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

  // set game manager variables here? Or move them to the init method for
  // Setup.m?
  [GameManager sharedGameManager].piecesPlayed1 = [[NSMutableArray alloc] init];
  [GameManager sharedGameManager].piecesPlayed2 = [[NSMutableArray alloc] init];

  [GameManager sharedGameManager].activeUser = 2;
  [GameManager sharedGameManager].userPieceSelected = YES;

  // Send user to setup screen to pick x or o piece
  CCScene *scene = [CCBReader loadAsScene:@"MainScene"];
  [[CCDirector sharedDirector] replaceScene:scene];
}

- (void)xButton {

  CCLOG(@"xButton button pushed");

  // set game manager variables here?
  [GameManager sharedGameManager].piecesPlayed1 = [[NSMutableArray alloc] init];
  [GameManager sharedGameManager].piecesPlayed2 = [[NSMutableArray alloc] init];

  [GameManager sharedGameManager].activeUser = 1;
  [GameManager sharedGameManager].userPieceSelected = YES;

  // Send user to setup screen to pick x or o piece
  CCScene *scene = [CCBReader loadAsScene:@"MainScene"];
  [[CCDirector sharedDirector] replaceScene:scene];
}

@end
