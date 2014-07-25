//
//  Grid.m
//  tictacslam
//
//  Created by Brian Schaper on 5/17/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "Grid.h"
#import "GamePiece.h"

#pragma mark -
#pragma Fixed Constants Rows / Columns
// these are fixed variables to ease readability in the code
static const int GRID_ROWS = 3;
static const int GRID_COLUMNS = 3;

@implementation Grid

#pragma mark -
#pragma mark Synthesize Properties
@synthesize gridArray, gamePieceHeight, gamePieceWidth, marginHeight,
    marginWidth, boardPosition, youLoseSprite, youWinSprite;

#pragma mark -
#pragma mark Setup

- (void)onEnter {

  [super onEnter];

  [self setupGrid];

  self.userInteractionEnabled = TRUE;

  CCLOG(@"onEnter");
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

      /*
    // create label to identify game piece by location using number label
    gamePiece.pieceLabel = [CCLabelTTF
        labelWithString:[NSString
                            stringWithFormat:@"%d", gamePiece.piecePosition]
               fontName:@"Garamond"
               fontSize:24];
    gamePiece.pieceLabel.position =
        ccp(gamePieceWidth * 0.5f, gamePieceHeight * 0.5f);
    [gamePiece addChild:gamePiece.pieceLabel];*/

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

#pragma mark -
#pragma mark Touch Handling

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {

  // get the x,y coordinates of the touch
  CGPoint touchLocation = [touch locationInNode:self];

  // load the game piece and get the row and column value by passing the touch
  // location to the method gamePieceForTouchPosition

  GamePiece *gamePiece = [self gamePieceForTouchPosition:touchLocation];

  // check if it is  my turn and if the piece is available
  if ([GameManager sharedGameManager].myTurn == true &&
      gamePiece.isActive == TRUE) {

    [self pieceSelected:gamePiece];
    [self checkForWinner];
    [self endTurn];

    [self performSelector:@selector(pieceGenerator)
               withObject:nil
               afterDelay:1.5];

    return;
  }

  CCLOG(@"this is the end of the touch began method");
}

- (void)pieceSelected:(GamePiece *)gamePiece {

  // receive a gamepiece and process selection

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
        [CCTexture textureWithFile:@"ccbResources/Export/x-piece.png"];
    [gamePiece setTexture:texture];

  } else if ([GameManager sharedGameManager].activeUser == 2) {
    gamePiece.pieceOwner = 2;

    // add the game piece object to the piecesPlayed array
    [[GameManager sharedGameManager].piecesPlayed2 addObject:gamePiece];

    // change sprite image based using the texture on the returned
    // gamePiece
    CCTexture *texture =
        [CCTexture textureWithFile:@"ccbResources/Export/o-piece.png"];
    [gamePiece setTexture:texture];
  }
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

#pragma mark -
#pragma mark Random Piece Generator
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

      GamePiece *randomPiece = [activeTempArray objectAtIndex:randomIndex];

      if (randomPiece.isActive == TRUE) {

        [self pieceSelected:randomPiece];
      }
    }

    [self checkForWinner];
    [self endTurn];
  }
}

#pragma mark -
#pragma mark Winner Check

- (BOOL)checkForWinner {

  CCLOG(@"checking for winner");

  // Use if statement to determine what user to check -
  if ([GameManager sharedGameManager].activeUser == 1) {

    // Use for loop to cycle through played pieces
    for (id item in [GameManager sharedGameManager].piecesPlayed1) {

      [self checkPieces:item];
    }

    // if not user 1, check if it's user 2
  } else if ([GameManager sharedGameManager].activeUser == 2) {

    // loop through the items that the user has played
    for (id item in [GameManager sharedGameManager].piecesPlayed2) {

      [self checkPieces:item];
    }
  }

  return 1;
}

- (BOOL)checkPieces:(GamePiece *)item {

  // read in the played pieces array to the playedstringset for comparison
  // against winning combos

  // finally we compare the intersection of the two arrays
  for (id combo in [GameManager sharedGameManager].winningCombos) {

    NSMutableSet *intersection =
        [NSMutableSet setWithSet:[self playedPieces:item]];

    [intersection intersectSet:[NSSet setWithSet:combo]];

    if (intersection.count > 2) {

      CCLOG(@"we've found a winner");

      [GameManager sharedGameManager].gameOver = YES;

      // use if statement to determine if you're the current player
      if ([GameManager sharedGameManager].myTurn == YES) {

        // you win
        // add a notch to your wins belt
      } else if ([GameManager sharedGameManager].myTurn == NO) {

        // you lose
        // add another notch to your losing streak
      }

      // Send user to game over scene
      CCScene *scene = [CCBReader loadAsScene:@"GameOver"];
      [[CCDirector sharedDirector] replaceScene:scene];

      return 1;
    }
  }

  return 1;
}

- (id)playedPieces:(GamePiece *)item {

  // create array to store values of played pieces
  NSMutableSet *playedStringsSet = [[NSMutableSet alloc] init];

  if ([GameManager sharedGameManager].activeUser == 1) {

    for (GamePiece *item in [GameManager sharedGameManager].piecesPlayed1) {

      // add the contents of the pieces played to a temporary nsset
      GamePiece *tempGamePiece = [[GamePiece alloc] init];
      tempGamePiece = item;

      // convert the value of the played pieces to strings that can be read
      // into
      // an nsset
      NSString *gamePieceString =
          [NSString stringWithFormat:@"%d", tempGamePiece.piecePosition];
      [playedStringsSet addObject:gamePieceString];
    }

  } else if ([GameManager sharedGameManager].activeUser == 2) {

    for (GamePiece *item in [GameManager sharedGameManager].piecesPlayed2) {

      // add the contents of the pieces played to a temporary nsset
      GamePiece *tempGamePiece = [[GamePiece alloc] init];
      tempGamePiece = item;

      // convert the value of the played pieces to strings that can be read
      // into
      // an nsset
      NSString *gamePieceString =
          [NSString stringWithFormat:@"%d", tempGamePiece.piecePosition];
      [playedStringsSet addObject:gamePieceString];
    }
  }
  return playedStringsSet;
}

#pragma mark -
#pragma mark Cleanup

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

@end
