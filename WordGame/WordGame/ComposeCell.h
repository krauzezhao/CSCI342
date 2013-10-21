//
//  ComposeCell.h
//  WordGame
//
//  Created by Brendan Dickinson on 18/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "ItemCell.h"

static const int NUM_ITEMS_PER_COMPOSECELL = 12;
static const int NUM_ITEMS_PER_ROW = 4;
static const int OFFSET_Y = 3;

@interface ComposeCell : UICollectionViewCell

///*** PRIVATE ***///
@property int nNumItems;
@property (strong, nonatomic) NSMutableArray* items;
@property (strong, nonatomic) id<ItemCellDelegate> delegate;
///*** END OF PRIVATE ***///

// The count of items should be no greater than NUM_ITEMS_PER_COMPOSECELL,
// otherwise the rest are ignored
// numOfItems: index is the item index, and the element is its number
- (void)setItems:(NSMutableArray *)numOfItems offset:(int)offset;
// whether this cell is set
- (BOOL)isSet;

@end
