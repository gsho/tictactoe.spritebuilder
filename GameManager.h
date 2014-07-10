//
//  GameManager.h
//  tictacslam
//
//  Created by Brian Schaper on 6/26/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameManager : CCNode {

  int activeUser;

  int activeUser2;

  int winsValue;
  int lossesValue;

  NSMutableArray *piecesPlayed1;
  NSMutableArray *piecesPlayed2;
}

@property int activeUser;
@property int winsValue;
@property int lossesValue;

@property(nonatomic, retain) NSMutableArray *piecesPlayed1;
@property(nonatomic, retain) NSMutableArray *piecesPlayed2;

+ (GameManager *)sharedGameManager;

@end