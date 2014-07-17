//
//  Grid.h
//  tictacslam
//
//  Created by Brian Schaper on 5/17/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MainScene.h"

@interface Grid : CCSprite {

    //create variable that will story the 2d array
  NSMutableArray *gridArray;

    //use these variables to properly layout the grid with margins
  CGFloat gamePieceHeight;
  CGFloat gamePieceWidth;
  CGFloat marginHeight;
  CGFloat marginWidth;

    //use a variable to hold the piece position on the board
  int boardPosition;

    //move these sprites to a game over scene
  CCSprite *youWinSprite;
  CCSprite *youLoseSprite;
}

@property(nonatomic, retain) NSMutableArray *gridArray;

@property(nonatomic) CGFloat gamePieceHeight;
@property(nonatomic) CGFloat gamePieceWidth;
@property(nonatomic) CGFloat marginHeight;
@property(nonatomic) CGFloat marginWidth;

@property(nonatomic) int boardPosition;

@property(nonatomic, retain) CCSprite *youWinSprite;
@property(nonatomic, retain) CCSprite *youLoseSprite;

- (BOOL)checkForWinner;
- (void)endTurn;

@end
