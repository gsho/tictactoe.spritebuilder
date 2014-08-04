//
//  Setup.m
//  tictacslam
//
//  Created by Brian Schaper on 7/22/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "SetupScene.h"

@implementation SetupScene

- (void)didLoadFromCCB {

  [GameManager sharedGameManager].totalPiecesPlayed = 0;
  [GameManager sharedGameManager].drawGame = NO;
  [GameManager sharedGameManager].gameMode = 1;
  [GameManager sharedGameManager].gameOver = NO;

  [GameManager sharedGameManager].piecesPlayedX = nil;
  [GameManager sharedGameManager].piecesPlayedO = nil;

  [GameManager sharedGameManager].piecesPlayedX = [[NSMutableArray alloc] init];
  [GameManager sharedGameManager].piecesPlayedO = [[NSMutableArray alloc] init];
}

// process piece selection on user button touch

#pragma mark -
#pragma mark Main Scene Button Methods

- (void)oButton {

  CCLOG(@"SetupScene - oButton button pushed");

  [GameManager sharedGameManager].activePlayer = playerO;
  [GameManager sharedGameManager].playerPieceSelected = YES;

  // Send user to setup screen to pick x or o piece
  CCScene *scene = [CCBReader loadAsScene:@"MainScene"];
  [[CCDirector sharedDirector] replaceScene:scene];
}

- (void)xButton {

  CCLOG(@"SetupScene - xButton button pushed");

  [GameManager sharedGameManager].activePlayer = playerX;
  [GameManager sharedGameManager].playerPieceSelected = YES;

  // Send user to setup screen to pick x or o piece
  CCScene *scene = [CCBReader loadAsScene:@"MainScene"];
  [[CCDirector sharedDirector] replaceScene:scene];
}

@end
