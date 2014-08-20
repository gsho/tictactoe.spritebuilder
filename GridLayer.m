//
//  GridLayer.m
//  tictacslam
//
//  Created by Brian Schaper on 5/17/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "GridLayer.h"
#import "GamePiece.h"

#pragma mark -
#pragma Fixed Constants Rows / Columns

static const int GRID_ROWS = 3;
static const int GRID_COLUMNS = 3;

@implementation GridLayer

#pragma mark -
#pragma mark Synthesize Properties

@synthesize gridArray, gamePieceHeight, gamePieceWidth, marginHeight,
    marginWidth, boardPosition, winningCombos;

#pragma mark -
#pragma mark Setup

- (void)onEnter {

  CCLOG(@"GridLayer onEnter");

  [super onEnter];

  [self setupGrid];

  self.userInteractionEnabled = YES;
}

- (void)setupGrid {

  CCLOG(@"setupGrid");

  // first, create a gamePiece sprite and determine the height and width
  GamePiece *gamePieceSize = [[GamePiece alloc] initGamePiece];
  gamePieceHeight = gamePieceSize.contentSize.height;
  gamePieceWidth = gamePieceSize.contentSize.width;

  // get the content size of the gridLayer (i.e. "self") and subtract the number
  // of pieces in the gridLayer, then divide by the number of pieces in the row
  // or column
  marginWidth = ((self.contentSize.width) - (GRID_COLUMNS * gamePieceWidth)) /
                (GRID_COLUMNS + 1);
  marginHeight = ((self.contentSize.height) - (GRID_ROWS * gamePieceHeight)) /
                 (GRID_ROWS + 1);

  // setup the initial x and y positions based on the margin value
  float x = marginWidth;
  float y = marginHeight;

  // initialize the array as a blank NSMutableArray
  gridArray = [NSMutableArray array];

  // create a two dimension for loops to setup the gridLayer
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

      [self addChild:gamePiece];

      // use the array shorthand to assign the gridLayer position of the newly
      // created gamePiece to the gridArray
      gridArray[i][j] = gamePiece;

      x += gamePieceWidth + marginWidth;
    }

    y += gamePieceHeight + marginHeight;
  }

  CCLOG(@"gridLayer now setup");
}

#pragma mark -
#pragma mark Touch Handling

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {

  CCLOG(@"touchBegan");

  [[AudioManager sharedAudioManager] playSoundEffect:@"click.wav"];

  // get the x,y coordinates of the touch
  CGPoint touchLocation = [touch locationInNode:self];

  // load the game piece and get the row and column value by passing the touch
  // location to the method gamePieceForTouchPosition

  GamePiece *gamePiece = [self gamePieceForTouchPosition:touchLocation];

  // check if it is  my turn and if the piece is available
  if (gamePiece.isActive == TRUE) {

    [self pieceSelected:gamePiece];

    // check for winner then draw
    if ([self checkForWinner]) {

      CCLOG(@"there was a winner!");

      [GameManager sharedGameManager].gameOver = YES;

      CCScene *gameOverScene = [CCBReader loadAsScene:@"GameOverScene"];
      [[CCDirector sharedDirector] replaceScene:gameOverScene];

      return;

    } else if ([self checkForDraw]) {

      CCLOG(@"there was a tie!");

      [GameManager sharedGameManager].drawGame = YES;
      [GameManager sharedGameManager].gameOver = YES;

      CCScene *gameOverScene = [CCBReader loadAsScene:@"GameOverScene"];
      [[CCDirector sharedDirector] replaceScene:gameOverScene];

      return;
    }

    [self endTurn];

    // If game is not over, pass the move to the piece generator for CPU's turn
    // and in single player mode
    if ([GameManager sharedGameManager].gameOver == NO &&
        [GameManager sharedGameManager].gameMode == singlePlayer) {

      self.userInteractionEnabled = NO;
      [self performSelector:@selector(pieceGenerator)
                 withObject:nil
                 afterDelay:1.5];
    }
    return;
  }
}

- (void)pieceSelected:(GamePiece *)gamePiece {

  CCLOG(@"pieceSelected");

  // set the gamePiece to not active state
  gamePiece.isActive = FALSE;

  // increment total pieces played by 1
  [GameManager sharedGameManager].totalPiecesPlayed++;

  // assign the owner of the game piece to the active user
  if ([GameManager sharedGameManager].activePlayer == playerX) {
    gamePiece.pieceOwner = playerX;

    // add the game piece object to the piecesPlayed array
    [[GameManager sharedGameManager].piecesPlayedX addObject:gamePiece];

    // change sprite image based using the texture on the returned
    // gamePiece
    CCTexture *texture =
        [CCTexture textureWithFile:@"ccbResources/Export/x-piece.png"];
    [gamePiece setTexture:texture];

  } else if ([GameManager sharedGameManager].activePlayer == playerO) {
    gamePiece.pieceOwner = playerO;

    // add the game piece object to the piecesPlayed array
    [[GameManager sharedGameManager].piecesPlayedO addObject:gamePiece];

    // change sprite image based using the texture on the returned
    // gamePiece
    CCTexture *texture =
        [CCTexture textureWithFile:@"ccbResources/Export/o-piece.png"];
    [gamePiece setTexture:texture];
  }
}

- (GamePiece *)gamePieceForTouchPosition:(CGPoint)touchPosition {

  CCLOG(@"gamePieceForTouchPosition");

  // get the row and column that was touched, return the game piece inside
  // the corresponding column and row

  int row = touchPosition.y / gamePieceHeight;
  int column = touchPosition.x / gamePieceWidth;

  return gridArray[row][column];
}

#pragma mark -
#pragma mark Random Piece Generator

- (void)pieceGenerator {

  CCLOG(@"called pieceGenerator");

  [[AudioManager sharedAudioManager] playSoundEffect:@"click.wav"];

  // randomly generate piece, by accessing the gridArray and randomly picking
  // a piece that is still active from the list of active game pieces

  // first create an active temporary array that we'll store our available
  // pieces in

  NSMutableArray *activeTempArray = [NSMutableArray array];

  // Loop to find the active pieces and store them in our newly created array
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

  // check for winner then draw
  if ([self checkForWinner]) {

    CCLOG(@"there was a winner!");
    [GameManager sharedGameManager].drawGame = NO;
    [GameManager sharedGameManager].gameOver = YES;

    CCScene *gameOverScene = [CCBReader loadAsScene:@"GameOverScene"];
    [[CCDirector sharedDirector] replaceScene:gameOverScene];

    return;

  } else if ([self checkForDraw]) {

    CCLOG(@"there was a tie!");
    [GameManager sharedGameManager].drawGame = YES;
    [GameManager sharedGameManager].gameOver = YES;

    CCScene *gameOverScene = [CCBReader loadAsScene:@"GameOverScene"];
    [[CCDirector sharedDirector] replaceScene:gameOverScene];

    return;
  }

  [self endTurn];
  self.userInteractionEnabled = YES;
  return;
}

#pragma mark -
#pragma mark Winner Check

- (BOOL)checkForWinner {

  CCLOG(@"checking for winner");

  if ([GameManager sharedGameManager].activePlayer == playerX) {

    // Use for loop to cycle through played pieces
    for (id item in [GameManager sharedGameManager].piecesPlayedX) {

      return [self checkPieces:item];
    }

  } else if ([GameManager sharedGameManager].activePlayer == playerO) {

    // loop through the items that the user has played
    for (id item in [GameManager sharedGameManager].piecesPlayedO) {

      return [self checkPieces:item];
    }
  }

  return NO;
}

- (BOOL)checkForDraw {

  CCLOG(@"checking for draw");

  if ([GameManager sharedGameManager].totalPiecesPlayed == 9) {

    return YES;
  }

  return NO;
}

- (BOOL)checkPieces:(GamePiece *)item {

  // comparing played pieces against winning combos

  // 1 setup the winning combinations using nsset
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

  // add the sets to a new set holding all possible winning combos
  winningCombos =
      [NSMutableSet setWithObjects:c1, c2, c3, c4, c5, c6, c7, c8, nil];

  // finally we compare the intersection of the two arrays
  for (id combo in self.winningCombos) {

    NSMutableSet *intersection =
        [NSMutableSet setWithSet:[self playedPieces:item]];

    [intersection intersectSet:[NSSet setWithSet:combo]];

    if (intersection.count > 2) {

      [GameManager sharedGameManager].gameOver = YES;

      // use if statement to determine if you're the current player
      if ([GameManager sharedGameManager].activePlayer == playerO) {

        return YES;

      } else if ([GameManager sharedGameManager].activePlayer == playerX) {

        return YES;
      }
    }
  }

  return NO;
}

- (id)playedPieces:(GamePiece *)item {

  // create array to store values of played pieces
  NSMutableSet *playedStringsSet = [[NSMutableSet alloc] init];

  if ([GameManager sharedGameManager].activePlayer == playerX) {

    for (GamePiece *item in [GameManager sharedGameManager].piecesPlayedX) {

      // add the contents of the pieces played to a temporary nsset
      GamePiece *tempGamePiece = item;

      // convert the value of the played pieces to strings that can be read
      // into an nsset
      NSString *gamePieceString =
          [NSString stringWithFormat:@"%d", tempGamePiece.piecePosition];
      [playedStringsSet addObject:gamePieceString];
    }

  } else if ([GameManager sharedGameManager].activePlayer == playerO) {

    for (GamePiece *item in [GameManager sharedGameManager].piecesPlayedO) {

      // add the contents of the pieces played to a temporary nsset
      GamePiece *tempGamePiece = item;

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

  if ([GameManager sharedGameManager].gameOver == NO) {

    // switch user label
    if ([GameManager sharedGameManager].activePlayer == playerX) {

      [GameManager sharedGameManager].activePlayer = playerO;

    } else if ([GameManager sharedGameManager].activePlayer == playerO) {

      [GameManager sharedGameManager].activePlayer = playerX;
    }
  }
}

- (void)dealloc {
  CCLOG(@"GridLayer Dealloc");
}

@end
