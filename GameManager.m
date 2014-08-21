//
//  GameManager.m
//  tictacslam
//
//  Created by Brian Schaper on 6/26/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "GameManager.h"

@implementation GameManager

@synthesize activePlayer, piecesPlayedX, piecesPlayedO, playerPieceSelected,
    gameOver, totalPiecesPlayed, drawGame, gameMode;

static GameManager *_sharedGameManager = nil;

+ (GameManager *)sharedGameManager {

  @synchronized(self) {

    if (_sharedGameManager == nil) {
      _sharedGameManager = [[GameManager alloc] init];
    }
  }

  return _sharedGameManager;
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
  }

  CCLOG(@"GameManager init");

  return self;
}

- (void)dealloc {

  CCLOG(@"GameManager dealloc");
}

@end
