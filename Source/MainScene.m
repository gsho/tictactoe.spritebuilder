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

#pragma mark Variables

@synthesize turnLabel, winsLabel, lossesLabel;

#pragma mark -
#pragma mark Loading

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



  winsLabel.string = [NSString
      stringWithFormat:@"%d", [GameManager sharedGameManager].winsValue];
  lossesLabel.string = [NSString
      stringWithFormat:@"%d", [GameManager sharedGameManager].lossesValue];
  turnLabel.string = @" ";
}

// Could this be moved to the GameManager?  No, this is used to update the
// labels setup in the MainScene instance
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
#pragma mark -
#pragma mark Main Scene Button Methods

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

#pragma mark -
#pragma mark dealloc

- (void)dealloc {

  // remember to remove the observer
  [[GameManager sharedGameManager] removeObserver:self
                                       forKeyPath:@"activeUser"];
}

@end
