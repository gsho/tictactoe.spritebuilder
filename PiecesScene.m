//
//  PiecesScene.m
//  tictacslam
//
//  Created by Brian Schaper on 8/7/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "PiecesScene.h"

@implementation PiecesScene

#pragma mark -
#pragma mark Main Scene Button Methods

- (void)oButton {

  CCLOG(@"oButton button pushed");
    
    [[AudioManager sharedAudioManager] playSoundEffect:@"click.wav"];

  [GameManager sharedGameManager].activePlayer = playerO;
  [GameManager sharedGameManager].playerPieceSelected = YES;

  // Send user to setup screen to pick x or o piece
  CCScene *scene = [CCBReader loadAsScene:@"MainScene"];
  [[CCDirector sharedDirector] replaceScene:scene];
}

- (void)xButton {

  CCLOG(@"xButton button pushed");
    
    [[AudioManager sharedAudioManager] playSoundEffect:@"click.wav"];

  [GameManager sharedGameManager].activePlayer = playerX;
  [GameManager sharedGameManager].playerPieceSelected = YES;

  // Send user to setup screen to pick x or o piece
  CCScene *scene = [CCBReader loadAsScene:@"MainScene"];
  [[CCDirector sharedDirector] replaceScene:scene];
}

@end
