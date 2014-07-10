//
//  GamePiece.h
//  tictacslam
//
//  Created by Brian Schaper on 5/17/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GamePiece : CCSprite {

  BOOL isActive;
  int piecePosition;
  int pieceOwner;

  CCLabelTTF *pieceLabel;
}

// stores the current state of the creature

@property(nonatomic, assign) BOOL isActive;
@property(nonatomic, assign) int piecePosition;
@property(nonatomic, assign) int pieceOwner;
@property(nonatomic, retain) CCLabelTTF *pieceLabel;

- (id)initGamePiece;
- (void)setInactive;

@end
