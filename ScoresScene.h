//
//  Scores.h
//  tictacslam
//
//  Created by Brian Schaper on 7/24/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ScoresScene : CCNode {

  CCLabelTTF *xValueLabel;
  CCLabelTTF *oValueLabel;
  CCLabelTTF *drawsValueLabel;
}

@property(retain, nonatomic) CCLabelTTF *xValueLabel;
@property(retain, nonatomic) CCLabelTTF *oValueLabel;
@property(retain, nonatomic) CCLabelTTF *drawsValueLabel;
@end
