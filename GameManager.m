//
//  GameManager.m
//  tictacslam
//
//  Created by Brian Schaper on 6/26/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "GameManager.h"

@implementation GameManager

@synthesize activeUser, winsValue, lossesValue, piecesPlayed1, piecesPlayed2,
    userPieceSelected, myTurn, draws, gameOver, winningCombos;

static GameManager *_sharedGameManager = nil;

+ (GameManager *)sharedGameManager {

  @synchronized([GameManager class]) {

    if (!_sharedGameManager) {

      [[self alloc] init];
    }

    return _sharedGameManager;
  }
  return nil;
}

#pragma mark -
#pragma mark Init/Alloc Methods

+ (id)alloc {

  @synchronized([GameManager class]) {

    NSAssert(
        _sharedGameManager == nil,
        @"Attempted to allocate a second instance of the MainScene singleton");
    _sharedGameManager = [super alloc];
    return _sharedGameManager;
  }
  return nil;
}

- (id)init {

  if (self = [super init]) {

    // set game manager variables here?
    CCLOG(@"GameManager Init - setting game variables");

    // why aren't these variables being initialized in the game manager?
    self.winsValue = 1;
    self.lossesValue = 1;
    self.userPieceSelected = false;
    self.myTurn = true;

    self.activeUser = 1;

    // 1 setup the winning combinations using nsset

    NSMutableSet *c1 =
        [[NSMutableSet alloc] initWithObjects:@"1", @"2", @"3", nil];
    NSMutableSet *c2 =
        [[NSMutableSet alloc] initWithObjects:@"4", @"5", @"6", nil];
    NSMutableSet *c3 =
        [[NSMutableSet alloc] initWithObjects:@"7", @"8", @"9", nil];
    NSMutableSet *c4 =
        [[NSMutableSet alloc] initWithObjects:@"1", @"4", @"7", nil];
    NSMutableSet *c5 =
        [[NSMutableSet alloc] initWithObjects:@"2", @"5", @"8", nil];
    NSMutableSet *c6 =
        [[NSMutableSet alloc] initWithObjects:@"3", @"6", @"9", nil];
    NSMutableSet *c7 =
        [[NSMutableSet alloc] initWithObjects:@"1", @"5", @"9", nil];
    NSMutableSet *c8 =
        [[NSMutableSet alloc] initWithObjects:@"3", @"5", @"7", nil];

    // add the sets to a new set holding all possible winning combos
    winningCombos =
        [NSMutableSet setWithObjects:c1, c2, c3, c4, c5, c6, c7, c8, nil];
  }

  return self;
}

@end
