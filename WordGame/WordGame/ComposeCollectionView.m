//
//  ComposeCollectionView.m
//  WordGame
//
//  Created by Brendan Dickinson on 18/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import "ComposeCollectionView.h"

@implementation ComposeCollectionView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        self.dataSource = self;
        self.delegate = self;
    }
    return self;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    _items = _player.items;
    return ceil(_items.count * 1.0 / NUM_ITEMS_PER_COMPOSECELL);
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ComposeCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell"
                                                                           forIndexPath:indexPath];
    if ([cell isSet] == NO)
    {
        cell.delegate = _itemDelegate;
        // the items
        NSRange range = {indexPath.row * NUM_ITEMS_PER_COMPOSECELL, NUM_ITEMS_PER_COMPOSECELL};
        if (range.location + range.length >= _items.count)
            range.length = _items.count - range.location;
        NSMutableArray* items = [[_items subarrayWithRange:range] mutableCopy];
        [cell setItems:items];
    }
    return cell;
}

// the padding
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(PADDING, PADDING, PADDING, PADDING);
}

// the cell size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.frame.size.width - 2 * PADDING,
                      self.frame.size.height - 2 * PADDING);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int nPage = self.contentOffset.x / (self.frame.size.width / NUM_PAGES);
    [_ccvdDelegate pageWasScrolledTo:nPage];
}

@end
