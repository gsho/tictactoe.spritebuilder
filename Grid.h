//
//  Grid.h
//  tictacslam
//
//  Created by Brian Schaper on 5/17/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Grid : CCSprite {

  NSMutableArray *gridArray;
  CGFloat gamePieceHeight;
  CGFloat gamePieceWidth;
  CGFloat marginHeight;
  CGFloat marginWidth;
  int boardPosition;
}

@property(nonatomic, retain) NSMutableArray *gridArray;
@property(nonatomic) CGFloat gamePieceHeight;
@property(nonatomic) CGFloat gamePieceWidth;
@property(nonatomic) CGFloat marginHeight;
@property(nonatomic) CGFloat marginWidth;
@property(nonatomic) int boardPosition;

- (BOOL)checkForWinner;
- (void)endTurn;

@end
