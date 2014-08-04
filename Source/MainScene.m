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

@synthesize turnLabel, winsLabel, lossesLabel;

#pragma mark -
#pragma mark Loading

- (void)didLoadFromCCB {

  // setup things like a timer or anything else you want to start when the main
  // scene is loaded

  CCLOG(@"MainScene init");

  // set the default starting value of Wins and Losses - these values you should
  // be transferred to a cached location for future sessions, along with name
  // and ability to post to server

  if ([GameManager sharedGameManager].activePlayer == playerX) {
    turnLabel.string = @"X";

  } else if ([GameManager sharedGameManager].activePlayer == playerO) {
    turnLabel.string = @"O";
  }

  [[GameManager sharedGameManager] addObserver:self
                                    forKeyPath:@"activePlayer"
                                       options:0
                                       context:NULL];
}

// Used to update the labels setup in the MainScene instance
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {

  if ([keyPath isEqualToString:@"activePlayer"]) {

    if ([GameManager sharedGameManager].activePlayer == playerX) {
      turnLabel.string = @"X";
      return;
    } else if ([GameManager sharedGameManager].activePlayer == playerO) {
      turnLabel.string = @"O";
      return;
    }
  }
}
#pragma mark -
#pragma mark Main Scene Button Methods

- (void)play {

  CCLOG(@"MainScene - play button pushed");

  if ([GameManager sharedGameManager].playerPieceSelected == NO) {

    // Send user to setup screen to pick x or o piece
    CCScene *scene = [CCBReader loadAsScene:@"SetupScene"];
    [[CCDirector sharedDirector] replaceScene:scene];

  } else {

    // Send them to the main scene if they already have their piece selected
    CCScene *scene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:scene];
  }
}

- (void)reset {

  CCLOG(@"MainScene - reset button pushed");

  // reset all game values
  [GameManager sharedGameManager].playerPieceSelected = NO;
  [GameManager sharedGameManager].piecesPlayedX = nil;
  [GameManager sharedGameManager].piecesPlayedO = nil;

  [GameManager sharedGameManager].piecesPlayedX = [[NSMutableArray alloc] init];
  [GameManager sharedGameManager].piecesPlayedO = [[NSMutableArray alloc] init];

  CCScene *scene = [CCBReader loadAsScene:@"MainScene"];
  [[CCDirector sharedDirector] replaceScene:scene];
}

#pragma mark -
#pragma mark dealloc

- (void)dealloc {

  NSLog(@"dealloc MainScene");

  // remember to remove the observer
  [[GameManager sharedGameManager] removeObserver:self
                                       forKeyPath:@"activePlayer"];
}

@end
