//
//  PlayersScene.m
//  tictacslam
//
//  Created by Brian Schaper on 8/7/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "PlayersScene.h"

@implementation PlayersScene

- (void)didLoadFromCCB {

  // Use setupscene to initialize game variables
  [GameManager sharedGameManager].gameMode = singlePlayer;

  [GameManager sharedGameManager].totalPiecesPlayed = 0;
  [GameManager sharedGameManager].drawGame = NO;
  [GameManager sharedGameManager].gameOver = NO;

  [GameManager sharedGameManager].piecesPlayedX = nil;
  [GameManager sharedGameManager].piecesPlayedO = nil;

  [GameManager sharedGameManager].piecesPlayedX = [[NSMutableArray alloc] init];
  [GameManager sharedGameManager].piecesPlayedO = [[NSMutableArray alloc] init];
}

- (void)one {

  CCLOG(@"one player");

  [[AudioManager sharedAudioManager] playSoundEffect:@"click.wav"];

  // set player mode
  [GameManager sharedGameManager].gameMode = singlePlayer;

  // Send user to setup screen to pick x or o piece
  CCScene *scene = [CCBReader loadAsScene:@"PiecesScene"];
  [[CCDirector sharedDirector] replaceScene:scene];
}

- (void)two {

  CCLOG(@"two player");

  [[AudioManager sharedAudioManager] playSoundEffect:@"click.wav"];

  // set player mode
  [GameManager sharedGameManager].gameMode = twoPlayer;

  // show piece selection elements
  // Send user to setup screen to pick x or o piece
  CCScene *scene = [CCBReader loadAsScene:@"PiecesScene"];
  [[CCDirector sharedDirector] replaceScene:scene];
}

- (void)settings {

  CCLOG(@"PlayersScene - settings button pushed");

  [[AudioManager sharedAudioManager] playSoundEffect:@"click.wav"];

  // Send user to setup screen to pick x or o piece
  CCScene *scene = [CCBReader loadAsScene:@"SettingsScene"];
  [[CCDirector sharedDirector] replaceScene:scene];
}

@end
