//
//  MainScene.h
//  TicTacSlam
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface MainScene : CCNode {

  CCLabelTTF *winsLabel;
  CCLabelTTF *lossesLabel;
  CCLabelTTF *turnLabel;

}

@property(nonatomic, retain) CCLabelTTF *winsLabel;
@property(nonatomic, retain) CCLabelTTF *lossesLabel;
@property(nonatomic, retain) CCLabelTTF *turnLabel;



@end
