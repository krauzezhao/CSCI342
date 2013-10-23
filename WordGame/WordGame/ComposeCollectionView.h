//
//  ComposeCollectionView.h
//  WordGame
//
//  Created by Brendan Dickinson on 18/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <math.h>
#import "ComposeCell.h"
#import "Constants.h"
#import "ItemCell.h"

static const CGFloat PADDING = 10;
static const int NUM_PAGES = 2;

@protocol ComposeCollectionViewDelegate <NSObject>

@required
- (void)pageWasScrolledTo:(int)page;

@end

@interface ComposeCollectionView : UICollectionView <UICollectionViewDataSource,
                                                     UICollectionViewDelegate,
                                                     UICollectionViewDelegateFlowLayout,
                                                     UIScrollViewDelegate>

@property (strong, nonatomic) NSMutableArray* items;
@property (weak, nonatomic) id<ComposeCollectionViewDelegate> ccvdDelegate;
@property (weak, nonatomic) id<ItemCellDelegate> itemDelegate;

// to reset the number of items
- (void)setNumberOfItems:(ItemIndex)item num:(int)num;
@end
