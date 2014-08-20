//
//  GamePiece.m
//  tictacslam
//
//  Created by Brian Schaper on 5/17/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "GamePiece.h"

@implementation GamePiece

@synthesize isActive, piecePosition, pieceOwner, pieceLabel;

- (id)initGamePiece {

  // initialize game piece

  if (self =
          [super initWithImageNamed:@"ccbResources/Export/blank-piece.png"]) {
    // setup properties of game piece here after verifying self has been created
    self.isActive = YES;
    self.piecePosition = 0;
    self.pieceOwner = 0;
    self.pieceLabel = nil;
  }

  return self;
}

- (void)setInactive {

  CCLOG(@"GamePiece setInactive");

  // set the piece to be inactive once selected

  self.userInteractionEnabled = NO;
}

- (NSString *)description {
  return [NSString
      stringWithFormat:
          @"\nis piece active: %d \npiece owner: %d\npiece position: %d",
          self.isActive, self.pieceOwner, self.piecePosition];
}

#pragma mark -
#pragma mark Cleanup

- (void)dealloc {

  CCLOG(@"GamePiece dealloc");

  // empty dealloc
}

@end
