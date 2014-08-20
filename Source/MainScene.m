//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"

@implementation MainScene

#pragma mark Variables

@synthesize turnValue;

#pragma mark -
#pragma mark Loading

- (void)didLoadFromCCB {

  [[GameManager sharedGameManager] addObserver:self
                                    forKeyPath:@"activePlayer"
                                       options:0
                                       context:NULL];

  // setup things like a timer or anything else you want to start when the main
  // scene is loaded

  CCLOG(@"MainScene init");

  // set the default starting value of Wins and Losses - these values you should
  // be transferred to a cached location for future sessions, along with name
  // and ability to post to server

  if ([GameManager sharedGameManager].activePlayer == playerX) {
    turnValue.string = @"X";

  } else if ([GameManager sharedGameManager].activePlayer == playerO) {
    turnValue.string = @"O";
  }
}

// Used to update the labels setup in the MainScene instance
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {

  if ([keyPath isEqualToString:@"activePlayer"]) {

    if ([GameManager sharedGameManager].activePlayer == playerX) {
      turnValue.string = @"X";
      return;
    } else if ([GameManager sharedGameManager].activePlayer == playerO) {
      turnValue.string = @"O";
      return;
    }
  }
}
#pragma mark -
#pragma mark Main Scene Button Methods

- (void)home {

  CCLOG(@"MainScene - home button pushed");

  [[AudioManager sharedAudioManager] playSoundEffect:@"click.wav"];

  // Send user to setup screen to pick x or o piece
  CCScene *scene = [CCBReader loadAsScene:@"PlayersScene"];
  [[CCDirector sharedDirector] replaceScene:scene];
}

- (void)reset {
    
    

  CCLOG(@"MainScene - reset button pushed");

  [[AudioManager sharedAudioManager] playSoundEffect:@"click.wav"];

  // possibly reset game variables, but keep same player/piece selection? Or
  // should it bump back to piece selection?

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

- (void)settings {

  CCLOG(@"MainScene - settings button pushed");

  [[AudioManager sharedAudioManager] playSoundEffect:@"click.wav"];

  // Send user to setup screen to pick x or o piece
  CCScene *scene = [CCBReader loadAsScene:@"SettingsScene"];
  [[CCDirector sharedDirector] replaceScene:scene];
}

- (void)scores {

  CCLOG(@"MainScene - scores button pushed");

  [[AudioManager sharedAudioManager] playSoundEffect:@"click.wav"];

  // Send user to setup screen to pick x or o piece
  CCScene *scene = [CCBReader loadAsScene:@"ScoresScene"];
  [[CCDirector sharedDirector] replaceScene:scene];
}

#pragma mark -
#pragma mark dealloc

- (void)dealloc {

  CCLOG(@"dealloc MainScene");

  // remember to remove the observer
  [[GameManager sharedGameManager] removeObserver:self
                                       forKeyPath:@"activePlayer"];
}

@end
