//
//  ItemDescriptionView.h
//  WordGame
//
//  Created by Brendan Dickinson on 29/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"

static const float PERCENTAGE_HEIGHT_NAMELABEL = .1;
static const int IDV_PADDING = 3;

@interface ItemDescriptionView : UIView

///*** PRIVATE ***///
@property (strong, nonatomic) UILabel* nameLabel; // the item name
@property (strong, nonatomic) UITextView* descriptionTextView; // the item description
///*** END OF PRIVATE ***///

- (void)setItem:(ItemIndex)item;

///*** PRIVATE ***///
// init
- (void)initNameLabel;
- (void)initDescriptionTextView;
///*** END OF PRIVATE ***///

@end
