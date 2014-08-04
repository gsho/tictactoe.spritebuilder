//
//  GameOverScene.h
//  tictacslam
//
//  Created by Brian Schaper on 7/16/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameOverScene : CCNode {

  // variables to setup the game over scene

  CCSprite *oWins;
  CCSprite *xWins;
  CCSprite *draw;
}

@property(nonatomic, retain) CCSprite *oWins;
@property(nonatomic, retain) CCSprite *xWins;
@property(nonatomic, retain) CCSprite *draw;

@end
