//
//  GameOver.h
//  tictacslam
//
//  Created by Brian Schaper on 7/16/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameOver : CCNode {

  // variables to setup the game over scene
    
    CCSprite * youLose;
    CCSprite  * youWin;
}

@property (nonatomic, retain) CCSprite *youLose;
@property (nonatomic, retain) CCSprite *youWin;

@end
