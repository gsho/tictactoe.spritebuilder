//
//  MainScene.h
//  TicTacSlam
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface MainScene : CCNode {

  // variables to hold the wins/losses/draws/and turn

  CCLabelTTF *turnValue;
}

@property(nonatomic, retain) CCLabelTTF *turnValue;

@end
