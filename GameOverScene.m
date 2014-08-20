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

    // get current score and add one
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    int drawScore = (int)[defaults integerForKey:@"Draws"];
    drawScore++;
    [defaults setInteger:drawScore forKey:@"Draws"];
    [defaults synchronize];

    self.draw.visible = YES;

  } else if ([GameManager sharedGameManager].activePlayer == playerX) {

    // get current score and add one
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    int xWinsValue = (int)[defaults integerForKey:@"XWins"];
    xWinsValue++;
    [defaults setInteger:xWinsValue forKey:@"XWins"];
    [defaults synchronize];

    self.xWins.visible = YES;

  } else if ([GameManager sharedGameManager].activePlayer == playerO) {

    // get current score and add one
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int oWinsValue = (int)[defaults integerForKey:@"OWins"];
    oWinsValue++;
    [defaults setInteger:oWinsValue forKey:@"OWins"];
    [defaults synchronize];

    self.oWins.visible = YES;

    // add to number of owins
  }
}

- (void)home {

  CCLOG(@"home button pushed");

  [[AudioManager sharedAudioManager] playSoundEffect:@"click.wav"];

  // Send user to setup screen to pick x or o piece
  CCScene *scene = [CCBReader loadAsScene:@"PlayersScene"];
  [[CCDirector sharedDirector] replaceScene:scene];
}

- (void)replay {

  // reset all game variables and go back to main scene to play again
  [GameManager sharedGameManager].totalPiecesPlayed = 0;
  [GameManager sharedGameManager].drawGame = NO;
  [GameManager sharedGameManager].gameOver = NO;

  [GameManager sharedGameManager].piecesPlayedX = nil;
  [GameManager sharedGameManager].piecesPlayedO = nil;

  [GameManager sharedGameManager].piecesPlayedX = [[NSMutableArray alloc] init];
  [GameManager sharedGameManager].piecesPlayedO = [[NSMutableArray alloc] init];

  CCScene *scene = [CCBReader loadAsScene:@"MainScene"];
  [[CCDirector sharedDirector] replaceScene:scene];
}

- (void)scores {

  CCLOG(@"scores button pushed");

  [[AudioManager sharedAudioManager] playSoundEffect:@"click.wav"];

  // Send user to setup screen to pick x or o piece
  CCScene *scene = [CCBReader loadAsScene:@"ScoresScene"];
  [[CCDirector sharedDirector] replaceScene:scene];
}

- (void)settings {

  CCLOG(@"GameOverScene - settings button pushed");

  [[AudioManager sharedAudioManager] playSoundEffect:@"click.wav"];

  // Send user to setup screen to pick x or o piece
  CCScene *scene = [CCBReader loadAsScene:@"SettingsScene"];
  [[CCDirector sharedDirector] replaceScene:scene];
}

#pragma mark -
#pragma mark Cleanup

- (void)dealloc {
  CCLOG(@"GameOverScene Dealloc");
}

@end
