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
    userPieceSelected, myTurn, draws;

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

    self.piecesPlayed1 = [[NSMutableArray alloc] init];
    self.piecesPlayed2 = [[NSMutableArray alloc] init];
  }
  return self;
}

@end
