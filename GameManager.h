//
//  GameManager.h
//  tictacslam
//
//  Created by Brian Schaper on 6/26/14.
//  Copyright 2014 Apportable. All rights reserved.
//
//  GameManager Singleton control designed to support central application data

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameManager : CCNode {

  // Determine Active User by 1 or 2 - could push to enumerated type
  // declaration?
  int activeUser;

  // keep track of the total wins, losses, and ties
  int winsValue;
  int lossesValue;
  int draws;

  // Use array to store the slots each player has selected
  NSMutableArray *piecesPlayed1;
  NSMutableArray *piecesPlayed2;

  //
  bool userPieceSelected;
  bool myTurn;
}

@property int activeUser;
@property int winsValue;
@property int lossesValue;
@property int draws;

@property bool userPieceSelected;
@property bool myTurn;

@property(nonatomic, retain) NSMutableArray *piecesPlayed1;
@property(nonatomic, retain) NSMutableArray *piecesPlayed2;

+ (GameManager *)sharedGameManager;

@end
