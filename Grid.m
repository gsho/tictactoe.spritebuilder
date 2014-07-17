//
//  Grid.m
//  tictacslam
//
//  Created by Brian Schaper on 5/17/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "Grid.h"
#import "GamePiece.h"

// these are fixed variables to ease readability in the code
static const int GRID_ROWS = 3;
static const int GRID_COLUMNS = 3;

@implementation Grid

@synthesize gridArray, gamePieceHeight, gamePieceWidth, marginHeight,
    marginWidth, boardPosition, youLoseSprite, youWinSprite;

- (void)onEnter {

  [super onEnter];

  youWinSprite.visible = NO;
  youLoseSprite.visible = NO;

  if ([GameManager sharedGameManager].userPieceSelected == false) {
    // if the user hasn't chosen what piece they want to start with (x or y),
    // bring them
    // to the piece selection step
    [self userPieceSelection];
  } else {
    // no pieces have been selected, so begin to setup the pieces
    [self setupGrid];
  }

  self.userInteractionEnabled = TRUE;

  CCLOG(@"onEnter");
}

// Helper method to update visible properties of user selection step
- (void)userPieceSelection {

  for (CCSprite *choice in self.children) {
    // change visibility of sprite
    if (choice.visible == YES) {
      choice.visible = NO;
    } else if (choice.visible == NO) {
      choice.visible = YES;
    }
  }
}

- (void)setupGrid {

  // first, create a gamePiece sprite and determine the height and width
  GamePiece *gamePieceSize = [[GamePiece alloc] initGamePiece];
  gamePieceHeight = gamePieceSize.contentSize.height;
  gamePieceWidth = gamePieceSize.contentSize.width;

  // get the content size of the grid (i.e. "self") and subtract the number of
  // pieces in the grid, then divide by the number of pieces in the row or
  // column
  marginWidth = ((self.contentSize.width) - (GRID_COLUMNS * gamePieceWidth)) /
                (GRID_COLUMNS + 1);
  marginHeight = ((self.contentSize.height) - (GRID_ROWS * gamePieceHeight)) /
                 (GRID_ROWS + 1);

  // setup the initial x and y positions based on the margin value
  float x = marginWidth;
  float y = marginHeight;

  // initialize the array as a blank NSMutableArray
  gridArray = [NSMutableArray array];

  // create a two dimension for loops to setup the grid
  // start by iterating through each row, starting with the bottom row
  for (int i = 0; i < GRID_ROWS; i++) {

    // create the array and begin to assign the sprites positional index values
    gridArray[i] = [NSMutableArray array];

    // redefine the x position to be the marginWidth for each row iteration
    x = marginWidth;

    // once you've create the row, iterate through the individual columns, which
    // will turn out to be the individual space for the gamePiece
    for (int j = 0; j < GRID_COLUMNS; j++) {
      // create the individual game piece here using the initGamePiece message
      GamePiece *gamePiece = [[GamePiece alloc] initGamePiece];
      gamePiece.anchorPoint = ccp(0, 0);

      // set position of the piece using the x and y coordinates
      gamePiece.position = ccp(x, y);

      // increase the boardPosition by one and update the piece position for the
      // gamePiece
      boardPosition++;
      gamePiece.piecePosition = boardPosition;

      // create label to identify game piece by location using number label
      gamePiece.pieceLabel = [CCLabelTTF
          labelWithString:[NSString
                              stringWithFormat:@"%d", gamePiece.piecePosition]
                 fontName:@"Garamond"
                 fontSize:24];
      gamePiece.pieceLabel.position =
          ccp(gamePieceWidth * 0.5f, gamePieceHeight * 0.5f);
      [gamePiece addChild:gamePiece.pieceLabel];

      [self addChild:gamePiece];

      // use the array shorthand to assign the grid position of the newly
      // created gamePiece to the gridArray
      gridArray[i][j] = gamePiece;

      x += gamePieceWidth + marginWidth;
    }

    y += gamePieceHeight + marginHeight;
  }

  CCLOG(@"grid now setup");
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {

  // is it even my turn?  should I be allowed to even process a touch?
  if ([GameManager sharedGameManager].myTurn == true) {

    // get the x,y coordinates of the touch
    CGPoint touchLocation = [touch locationInNode:self];

    // setup the user piece based on their selection
    if ([GameManager sharedGameManager].userPieceSelected == false) {
      // go through the available children of the Grid setup in spritebuilder,
      // this is a simple approach when going through
      for (CCSprite *choice in self.children) {

        // confirm you are using the current choice by comparing each point
        if (CGRectContainsPoint(choice.boundingBox, touchLocation)) {

          if ([choice.name isEqual:@"x-piece"]) {

            [GameManager sharedGameManager].activeUser = 1;
            [GameManager sharedGameManager].userPieceSelected = true;
            [self userPieceSelection];
            [self setupGrid];

            return;

          } else if ([choice.name isEqual:@"o-piece"]) {

            [GameManager sharedGameManager].activeUser = 2;
            [GameManager sharedGameManager].userPieceSelected = true;
            [self userPieceSelection];
            [self setupGrid];

            return;
          }
        }
      }
    }

    // load the game piece and get the row and column value by passing the touch
    // location to the method gamePieceForTouchPosition

    GamePiece *gamePiece = [self gamePieceForTouchPosition:touchLocation];

    if (gamePiece.isActive == TRUE) {
      // set the gamePiece to not active
      gamePiece.isActive = FALSE;

      // assign the owner of the game piece to the active user
      if ([GameManager sharedGameManager].activeUser == 1) {
        gamePiece.pieceOwner = 1;

        // add the game piece object to the piecesPlayed array
        [[GameManager sharedGameManager].piecesPlayed1 addObject:gamePiece];

        // change sprite image based using the texture on the returned
        // gamePiece
        CCTexture *texture =
            [CCTexture textureWithFile:@"ccbResources/x-piece.png"];
        [gamePiece setTexture:texture];

      } else if ([GameManager sharedGameManager].activeUser == 2) {
        gamePiece.pieceOwner = 2;

        // add the game piece object to the piecesPlayed array
        [[GameManager sharedGameManager].piecesPlayed2 addObject:gamePiece];

        // change sprite image based using the texture on the returned
        // gamePiece
        CCTexture *texture =
            [CCTexture textureWithFile:@"ccbResources/o-piece.png"];
        [gamePiece setTexture:texture];
      }

      // check for winner by sending message to checkForWinner

      [self checkForWinner];
      [self endTurn];

      [self performSelector:@selector(pieceGenerator)
                 withObject:nil
                 afterDelay:1.0];

      return;

    } else if (gamePiece.isActive == FALSE) {
      CCLOG(@"attempted to select a non-active game piece");
      // do nothing, it's a non-active piece
      return;
    }

  } else if ([GameManager sharedGameManager].myTurn == false) {
    CCLOG(@"oops, it's not your turn yet, so don't touch!");
    return;
  }

  CCLOG(@"this is the end of the touch began method");
}

- (GamePiece *)gamePieceForTouchPosition:(CGPoint)touchPosition {

  // get the row and column that was touched, return the game piece inside
  // the
  // corresponding column and row
  int row = touchPosition.y / gamePieceHeight;
  int column = touchPosition.x / gamePieceWidth;

  // CCLOG(@"Piece selected is in row: %i and column: %i", row, column);

  return gridArray[row][column];
}

- (BOOL)checkForWinner {

  CCLOG(@"checking for winner");
  // setup the winning combinations using nsset

  NSMutableSet *c1 =
      [[NSMutableSet alloc] initWithObjects:@"1", @"2", @"3", nil];
  NSMutableSet *c2 =
      [[NSMutableSet alloc] initWithObjects:@"4", @"5", @"6", nil];
  NSMutableSet *c3 =
      [[NSMutableSet alloc] initWithObjects:@"7", @"8", @"9", nil];
  NSMutableSet *c4 =
      [[NSMutableSet alloc] initWithObjects:@"1", @"4", @"7", nil];
  NSMutableSet *c5 =
      [[NSMutableSet alloc] initWithObjects:@"2", @"5", @"8", nil];
  NSMutableSet *c6 =
      [[NSMutableSet alloc] initWithObjects:@"3", @"6", @"9", nil];
  NSMutableSet *c7 =
      [[NSMutableSet alloc] initWithObjects:@"1", @"5", @"9", nil];
  NSMutableSet *c8 =
      [[NSMutableSet alloc] initWithObjects:@"3", @"5", @"7", nil];

  NSMutableSet *winningCombos =
      [NSMutableSet setWithObjects:c1, c2, c3, c4, c5, c6, c7, c8, nil];

  // add new string value to the nsset that will be used for comparison
  NSMutableSet *playedStringsSet = [[NSMutableSet alloc] init];

  if ([GameManager sharedGameManager].activeUser == 1) {

    // use a for loop to go through the array assigned to user 1
    for (id item in [GameManager sharedGameManager].piecesPlayed1) {

      // CCLOG(@"item: %@", item);

      // check if played pieces are in any of the winning combinations
      // add the contents of the pieces played to a temporary nsset
      GamePiece *tempGamePiece = [[GamePiece alloc] init];
      tempGamePiece = item;
      // convert the value of the played pieces to strings that can be read into
      // an nsset
      NSString *gamePieceString =
          [NSString stringWithFormat:@"%d", tempGamePiece.piecePosition];
      [playedStringsSet addObject:gamePieceString];
      // CCLOG(@"playedStringsSet: %@", playedStringsSet);

      // then reset the gamePieceString back to nil
      gamePieceString = @"";

      // finally we compare the intersection of the two arrays
      for (id combo in winningCombos) {
        NSMutableSet *intersection = [NSMutableSet setWithSet:playedStringsSet];
        [intersection intersectSet:[NSSet setWithSet:combo]];
        // CCLOG(@"intersection results: %@", intersection);

        if (intersection.count > 2) {
          CCLOG(@"we've found a winner");
          // create the sprite with the image for the winner, but you don't
          // need to release it as the reset/play buttons will set them back to
          // invisible
          youWinSprite =
              [CCSprite spriteWithImageNamed:@"ccbResources/youwin.png"];
          youWinSprite.position = ccp(0.0f, self.contentSize.height / 2);
          [self addChild:youWinSprite];

          // also do one last check to see if there are no more pieces to play

          NSMutableArray *anymorePiecesTempArray;
          // iterate through 2d array
          for (int i = 0; i < [gridArray count]; i++) {
            for (int j = 0; j < [gridArray count]; j++) {
              // load temp game piece
              GamePiece *anymorePieces = [[GamePiece alloc] initGamePiece];

              if (anymorePieces.isActive == YES) {
                [anymorePiecesTempArray addObject:anymorePieces];
                // add to array
              } else {
                CCLOG(@"not an active piece");
              }
            }
          }

          [GameManager sharedGameManager].myTurn = false;
          return 1;
        }
      }
    }

  } else if ([GameManager sharedGameManager].activeUser == 2) {

    for (id item in [GameManager sharedGameManager].piecesPlayed2) {

      // CCLOG(@"item: %@", item);

      // check if played pieces are in any of the winning combinations
      // add the contents of the pieces played to a temporary nsset
      GamePiece *tempGamePiece = [[GamePiece alloc] init];
      tempGamePiece = item;
      // convert the value of the played pieces to strings that can be read into
      // an nsset
      NSString *gamePieceString =
          [NSString stringWithFormat:@"%d", tempGamePiece.piecePosition];
      [playedStringsSet addObject:gamePieceString];
      // CCLOG(@"playedStringsSet: %@", playedStringsSet);

      // then reset the gamePieceString back to nil
      gamePieceString = @"";

      // finally we compare the intersection of the two arrays
      for (id combo in winningCombos) {
        NSMutableSet *intersection = [NSMutableSet setWithSet:playedStringsSet];
        [intersection intersectSet:[NSSet setWithSet:combo]];
        // CCLOG(@"intersection results: %@", intersection);

        if (intersection.count > 2) {
          CCLOG(@"we've found a winner");
          // create the sprite with the image for the winner, but you don't
          // need to release it as the reset/play buttons will set them back to
          // invisible
          youWinSprite =
              [CCSprite spriteWithImageNamed:@"ccbResources/youwin.png"];
          youWinSprite.position = ccp(0.0f, self.contentSize.height / 2);
          [self addChild:youWinSprite];

          return 1;
        }
      }
    }
  }
  return 1;
}

// end turn and pass control to opposite party
- (void)endTurn {

  CCLOG(@"endTurn");
  // switch user label
  if ([GameManager sharedGameManager].activeUser == 1) {

    [GameManager sharedGameManager].activeUser = 2;

  } else if ([GameManager sharedGameManager].activeUser == 2) {

    [GameManager sharedGameManager].activeUser = 1;
  }

  if ([GameManager sharedGameManager].myTurn == true) {
    // if it was my turn, switch and send a message to the piece generator
    [GameManager sharedGameManager].myTurn = false;
    return;

  } else if ([GameManager sharedGameManager].myTurn == false) {
    [GameManager sharedGameManager].myTurn = true;
    return;
  }
}

- (void)pieceGenerator {

  CCLOG(@"called pieceGenerator");

  if ([GameManager sharedGameManager].myTurn == false) {
    // randomly generate piece, by accessing the gridArray and randomly picking
    // a piece that is still active from the list of active game pieces

    // first create an active temporary array that we'll store our available
    // pieces in
    NSMutableArray *activeTempArray = [NSMutableArray array];

    // then we use a for loop to find the active pieces and store them in our
    // newly created array

    // iterate over a 2d array to find active pieces
    for (int i = 0; i < [gridArray count]; ++i) {
      for (int j = 0; j < [gridArray count]; ++j) {

        // select a random index of active pieces temp array
        GamePiece *tempPiece = gridArray[i][j];
        if (tempPiece.isActive == TRUE) {
          // once the active piece has been found, we'll add the object to our
          // array
          [activeTempArray addObject:tempPiece];
        }
      }
    }

    // now we randomly choose a piece, suggesting the random index value to
    // assign a game piece and deactivate it.

    if ([activeTempArray count] > 0) {
      NSUInteger randomIndex = arc4random() % [activeTempArray count];

      CCLOG(@"activeTempArray randomobject: %@",
            [activeTempArray objectAtIndex:randomIndex]);

      GamePiece *randomPiece = [activeTempArray objectAtIndex:randomIndex];

      if (randomPiece.isActive == TRUE) {
        // set the gamePiece to not active
        randomPiece.isActive = FALSE;

        // assign the owner of the game piece to the active user
        if ([GameManager sharedGameManager].activeUser == 1) {
          randomPiece.pieceOwner = 1;

          // add the game piece object to the piecesPlayed array
          [[GameManager sharedGameManager].piecesPlayed1 addObject:randomPiece];

          // change sprite image based using the texture on the returned
          // gamePiece
          CCTexture *texture =
              [CCTexture textureWithFile:@"ccbResources/x-piece.png"];
          [randomPiece setTexture:texture];

        } else if ([GameManager sharedGameManager].activeUser == 2) {
          randomPiece.pieceOwner = 2;

          // add the game piece object to the piecesPlayed array
          [[GameManager sharedGameManager].piecesPlayed2 addObject:randomPiece];

          // change sprite image based using the texture on the returned
          // gamePiece
          CCTexture *texture =
              [CCTexture textureWithFile:@"ccbResources/o-piece.png"];
          [randomPiece setTexture:texture];
        } else if ([activeTempArray count] == 0)
          // game over, no winner
          CCLOG(@"no winner!");
      }
    }
  }
  [self checkForWinner];
  [self endTurn];
}

@end
