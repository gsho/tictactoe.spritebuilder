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

typedef enum : NSUInteger {
                 playerO,
                 playerX,
                 cpu,
               } Players;

@interface GameManager : CCNode {

  int activePlayer;
  int gameMode;

  int totalPiecesPlayed;

  BOOL playerPieceSelected;
  BOOL gameOver;
  BOOL drawGame;

  NSMutableArray *piecesPlayedX;
  NSMutableArray *piecesPlayedO;
}

@property int activePlayer;
@property int gameMode;

@property int totalPiecesPlayed;

@property BOOL playerPieceSelected;
@property BOOL gameOver;
@property BOOL drawGame;

@property(nonatomic, retain) NSMutableArray *piecesPlayedX;
@property(nonatomic, retain) NSMutableArray *piecesPlayedO;

+ (GameManager *)sharedGameManager;

@end
