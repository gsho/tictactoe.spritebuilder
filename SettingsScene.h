//
//  Settings.h
//  tictacslam
//
//  Created by Brian Schaper on 7/23/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface SettingsScene : CCNode {

  CCButton *soundButton;
  CCButton *musicButton;
}

@property(retain, atomic) CCButton *soundButton;
@property(retain, atomic) CCButton *musicButton;

@end
