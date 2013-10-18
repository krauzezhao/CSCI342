//
//  ComposeCollectionView.h
//  WordGame
//
//  Created by Brendan Dickinson on 18/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
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
@property (strong, nonatomic) id<ComposeCollectionViewDelegate> ccvdDelegate;
@property (strong, nonatomic) id<ItemCellDelegate> itemDelegate;


@end
