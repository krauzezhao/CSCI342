//
//  ComposeCell.h
//  WordGame
//
//  Created by Brendan Dickinson on 18/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemCell.h"

static const int NUM_ITEMS_PER_ROW = 4;

@interface ComposeCell : UICollectionViewCell

///*** PRIVATE ***///
@property int nNumItems;
@property (strong, nonatomic) NSMutableArray* items;
@property (strong, nonatomic) id<ItemCellDelegate> delegate;
///*** END OF PRIVATE ***///

- (void)setNumberOfItems:(int)num;

///*** PRIVATE ***///
- (void)layoutItems;
///*** END OF PRIVATE ***///

@end
