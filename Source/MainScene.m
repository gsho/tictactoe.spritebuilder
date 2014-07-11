//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"
#import "GamePiece.h"

@implementation MainScene

@synthesize turnLabel, winsLabel, lossesLabel;

- (void)didLoadFromCCB {

  // setup things like a timer or anything else you want to start when the main
  // scene is loaded

  CCLOG(@"init MainScene");

  // set the default starting value of Wins and Losses - these values you should
  // be transferred to a cached location for future sessions, along with name
  // and ability to post to server

  [[GameManager sharedGameManager] addObserver:self
                                    forKeyPath:@"activeUser"
                                       options:0
                                       context:NULL];

  [GameManager sharedGameManager].winsValue = 2;
  [GameManager sharedGameManager].lossesValue = 2;
  [GameManager sharedGameManager].userPieceSelected = false;

  [GameManager sharedGameManager].activeUser = 1;

  [GameManager sharedGameManager].piecesPlayed1 = [[NSMutableArray alloc] init];
  [GameManager sharedGameManager].piecesPlayed2 = [[NSMutableArray alloc] init];

  winsLabel.string = [NSString
      stringWithFormat:@"%d", [GameManager sharedGameManager].winsValue];
  lossesLabel.string = [NSString
      stringWithFormat:@"%d", [GameManager sharedGameManager].lossesValue];
  turnLabel.string = @" ";
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
  if ([keyPath isEqualToString:@"activeUser"]) {

    if ([GameManager sharedGameManager].activeUser == 1) {
      turnLabel.string = @"X";
      return;
    } else if ([GameManager sharedGameManager].activeUser == 2) {
      turnLabel.string = @"O";
      return;
    }
  }
}

- (void)play {

  CCLOG(@"play button pushed");
  CCScene *scene = [CCBReader loadAsScene:@"MainScene"];
  [[CCDirector sharedDirector] replaceScene:scene];
}

- (void)reset {

  CCLOG(@"reset button pushed");

  CCScene *scene = [CCBReader loadAsScene:@"MainScene"];
  [[CCDirector sharedDirector] replaceScene:scene];
}

- (void)dealloc {

  // remember to remove the observer
  [[GameManager sharedGameManager] removeObserver:self
                                       forKeyPath:@"activeUser"];
}

@end
