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
    userPieceSelected;

static GameManager *_sharedGameManager = nil;

+ (GameManager *)sharedGameManager {

  @synchronized([GameManager class]) {

    if (!_sharedGameManager)

      [[self alloc] init];

    return _sharedGameManager;
  }
  return nil;
}

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

@end
