//
//  Grid.m
//  tictacslam
//
//  Created by Brian Schaper on 5/17/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "Grid.h"
#import "GamePiece.h"

// these are variables that cannot be changed
static const int GRID_ROWS = 3;
static const int GRID_COLUMNS = 3;

@implementation Grid

@synthesize gridArray, gamePieceHeight, gamePieceWidth, marginHeight,
    marginWidth, boardPosition;

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

  NSLog(@"self content width: %f and self content height: %f",
        self.contentSize.width, self.contentSize.height);

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

  NSLog(@"marginWidth: %f and marginHeight: %f", marginWidth, marginHeight);

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
      NSLog(@"gamePiece position x: %f and y: %f", x, y);

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

  CCLOG(@"SetupGrid");
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {

  // get the x,y coordinates of the touch
  CGPoint touchLocation = [touch locationInNode:self];

  // get the row and column value by passing the touch location to the method
  // "gamePieceForTouchPosition"
  GamePiece *gamePiece = [self gamePieceForTouchPosition:touchLocation];

  if (gamePiece.isActive == TRUE) {
    // set the gamePiece to not active
    gamePiece.isActive = FALSE;

    // assign the owner of the game piece to the active user
    if ([GameManager sharedGameManager].activeUser == 1) {
      gamePiece.pieceOwner = 1;

      // add the game piece object to the piecesPlayed array
      [[GameManager sharedGameManager].piecesPlayed1 addObject:gamePiece];

      // change sprite image based using the texture on the returned gamePiece
      CCTexture *texture =
          [CCTexture textureWithFile:@"ccbResources/o-piece.png"];
      [gamePiece setTexture:texture];

    } else if ([GameManager sharedGameManager].activeUser == 2) {
      gamePiece.pieceOwner = 2;

      // add the game piece object to the piecesPlayed array
      [[GameManager sharedGameManager].piecesPlayed2 addObject:gamePiece];

      // change sprite image based using the texture on the returned gamePiece
      CCTexture *texture =
          [CCTexture textureWithFile:@"ccbResources/x-piece.png"];
      [gamePiece setTexture:texture];
    }

    [self checkForWinner];
    [self endTurn];

    return;

  } else if (gamePiece.isActive == FALSE) {
    CCLOG(@"attempted to select a non-active game piece");
    // do nothing, it's a non-active piece
    return;
  }
}

- (GamePiece *)gamePieceForTouchPosition:(CGPoint)touchPosition {

  // get the row and column that was touched, return the game piece inside the
  // corresponding column and row
  int row = touchPosition.y / gamePieceHeight;
  int column = touchPosition.x / gamePieceWidth;

  // CCLOG(@"Piece selected is in row: %i and column: %i", row, column);

  return gridArray[row][column];
}

// end turn and pass control to opposite party
- (void)endTurn {

  CCLOG(@"endTurn");

  if ([GameManager sharedGameManager].activeUser == 1) {
    // switch user
    [GameManager sharedGameManager].activeUser = 2;

  } else if ([GameManager sharedGameManager].activeUser == 2) {
    // switch user
    [GameManager sharedGameManager].activeUser = 1;
  }
}

- (BOOL)checkForWinner {

  // pass in active pieces for active user to determine if 3 in a row

  // winning combinations

  NSString *combo1 = @"123";
  NSString *combo2 = @"456";
  NSString *combo3 = @"789";
  NSString *combo4 = @"147";
  NSString *combo5 = @"258";
  NSString *combo6 = @"369";
  NSString *combo7 = @"159";
  NSString *combo8 = @"753";

  NSArray *winningCombos =
      [NSArray arrayWithObjects:combo1, combo2, combo3, combo4, combo5, combo6,
                                combo7, combo8, nil];

  // figure out a way to add piece owner and piece position to array and compare
  // against winning combination array

  // Step 1: sort array of nsmutablearray values based on piece position

  NSSortDescriptor *sortDescriptor =
      [NSSortDescriptor sortDescriptorWithKey:@"piecePosition" ascending:YES];
  [[GameManager sharedGameManager].piecesPlayed1
      sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
  [[GameManager sharedGameManager].piecesPlayed2
      sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];

  // Once array has been sorted, determine the active user and compare against
  // winning combinations

  if ([GameManager sharedGameManager].activeUser == 1) {

    // Initialize a temporary game piece, string to hold the pieces played, and
    // another temporary string)
    GamePiece *tempGamePiece = [[GamePiece alloc] init];
    NSMutableString *piecesPlayedString = [[NSMutableString alloc] init];
    NSString *newString = [[NSString alloc] init];

    // set the initial value of the pieces played string
    [piecesPlayedString setString:@""];

    // use a for loop to go through the array assigned to user 1
    for (id item in [GameManager sharedGameManager].piecesPlayed1) {

      tempGamePiece = item;

      // Use cclog to determine pieces location on the board
      CCLOG(@"User 1 - temp GamePiece piecePosition: %d",
            tempGamePiece.piecePosition);

      // we set the temp new string to an empty variable each time the piece is
      // added to the loop
      newString = @"";
      newString = [piecesPlayedString
          stringByAppendingFormat:@"%i", tempGamePiece.piecePosition];

      CCLOG(@"newString: %@", newString);
      [piecesPlayedString setString:@""];
      [piecesPlayedString appendString:newString];
      CCLOG(@"piecesPlayedString: %@", piecesPlayedString);
    }

    BOOL found = NO;
    for (NSString *s in winningCombos) {

      NSString *immutableString =
          [NSString stringWithString:piecesPlayedString];
      NSRange rangeValue =
          [immutableString rangeOfString:s options:NSCaseInsensitiveSearch];

      if (rangeValue.location != NSNotFound) {
        found = YES;
        CCLOG(@"Found winner.");
        break;
      } else {
        found = NO;
      }
    }

  } else if ([GameManager sharedGameManager].activeUser == 2) {

    GamePiece *tempGamePiece = [[GamePiece alloc] init];
    NSMutableString *piecesPlayedString = [[NSMutableString alloc] init];
    NSString *newString = [[NSString alloc] init];

    [piecesPlayedString setString:@""];

    for (id item in [GameManager sharedGameManager].piecesPlayed2) {

      tempGamePiece = item;

      CCLOG(@"User 1 - temp GamePiece piecePosition: %d",
            tempGamePiece.piecePosition);

      newString = @"";
      newString = [piecesPlayedString
          stringByAppendingFormat:@"%i", tempGamePiece.piecePosition];

      CCLOG(@"newString: %@", newString);
      [piecesPlayedString setString:@""];
      [piecesPlayedString appendString:newString];
      CCLOG(@"piecesPlayedString: %@", piecesPlayedString);
    }

    BOOL found = NO;
    for (NSString *s in winningCombos) {

      NSString *immutableString =
          [NSString stringWithString:piecesPlayedString];
      NSRange rangeValue =
          [immutableString rangeOfString:s options:NSCaseInsensitiveSearch];

      if (rangeValue.location != NSNotFound) {
        found = YES;
        CCLOG(@"Found winner.");
        break;
      } else {
        found = NO;
      }
    }
  }

  return 1;
}

@end
