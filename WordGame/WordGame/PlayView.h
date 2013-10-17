//
//  PlayView.h
//  WordGame
//
//  Created by Hong Zhao on 3/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <QuartzCore/QuartzCore.h>
#import <stdlib.h>
#import "Constants.h"
#import "Word.h"

// the space between the play view and the border
static const int SPACE = 0;
// the number of swaps needed to permute the letter array
static const int NUM_SWAPS = 20;

// the level enumeration
typedef enum _Level
{
    LV_MASTER1,
    LV_MASTER2,
    LV_MASTER3
}Level;

// the letter status
typedef enum _LetterStatus
{
    LS_SELECTED,
    LS_UNSELECTED
}LetterStatus;

// the letter image prefix
typedef  enum _LetterIndex{
    LI_BLACK,
    LI_BLUE,
    LI_DG,
    LI_GOLD,
    LI_GREY,
    LI_LG,
    LI_ORANGE,
    LI_PINK,
    LI_RED,
    LI_VIOLET
}LetterIndex;

__unused static const char* LETTER[] = {
    "black", "blue", "dg", "gold", "grey",
    "lg", "orange", "pink", "red", "violet"
};

// delegate when the letter is selected
@protocol LetterSelectionDelegate <NSObject>

@required
- (void)letterWasSelected:(NSString*)letter;

@end

@interface PlayView : UIView

@property (strong, nonatomic) id<LetterSelectionDelegate> delegate;
///*** PRIVATE ***///
@property int nDim; // the dimension of the brick region
@property (strong, nonatomic) NSMutableArray* maBrick;
@property (strong, nonatomic) NSMutableArray* prevBricks;
@property (strong, nonatomic) NSMutableArray* maLetters;
@property (strong, nonatomic) NSArray* words;
@property (strong, nonatomic) NSMutableArray* selectedLetters;
///*** END OF PRIVATE ***///

- (void)setLevel:(Level)level words:(NSArray*)words;
- (void)reshuffle;
///*** PRIVATE ***///
- (void)initLetters;
- (void)layoutBricks;
// events
- (void)letterWasSelected:(UITapGestureRecognizer*)tgr;
///*** END OF PRIVATE ***///
@end
