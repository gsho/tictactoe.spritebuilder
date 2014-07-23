//
//  GameOver.m
//  tictacslam
//
//  Created by Brian Schaper on 7/16/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "GameOver.h"

@implementation GameOver

// init methods
#pragma mark -
#pragma mark Loading

- (void)didLoadFromCCB {

  CCLOG(@"init GameOver Scene");

  // setup things like a timer or anything else you want to start when the main
  // scene is loaded

  // show winner

  // set array's back to nil
  // set userpieceselected back to NO

  [GameManager sharedGameManager].userPieceSelected = NO;
}

// reporting game data to server

// clean up items

@end
