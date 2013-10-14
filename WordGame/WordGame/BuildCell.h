//
//  BuildCell.h
//  WordGame
//
//  Created by Brendan Dickinson on 14/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

#define SPACE_TEXTFIELD 10
#define WIDTH_FACTOR .7

// delegate when an event occurs on the cell
@protocol BuildCellDelegate <NSObject>

@required
// parameter: the word in this cell
- (void)accessoryWasTapped:(NSString*)word;
// parameter:
// 1.the input in this cell
// 2.the type of the input: library name or word
- (void)inputWasFinished:(NSString*)input type:(LibraryInputType)type;

@end

// the cell
@interface BuildCell : UITableViewCell <UITextFieldDelegate>

@property (strong, nonatomic) id<BuildCellDelegate> delegate;

@property (strong, nonatomic) UITextField* tfInput;
@property LibraryInputType litType;

- (void)setAsLibraryName;
- (void)setAsWord;

// events
- (void)accessoryWasTapped;

@end
