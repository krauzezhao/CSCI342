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
        _items = [[NSMutableArray alloc] init];
        _cells = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)setNumberOfItems:(ItemIndex)item num:(int)num animated:(BOOL)animated
{
    // the compose cell
    int nIndex = item / NUM_ITEMS_PER_COMPOSECELL;
    NSIndexPath* ip = [NSIndexPath indexPathForItem:nIndex inSection:0];
    // to check if the cell is in current scroll screen
    if (animated)
    {
        ComposeCell* visible = [self.visibleCells objectAtIndex:0];
        int nVisibleRow = [self indexPathForCell:visible].row;
        if (nVisibleRow > ip.row) // invisible
            // The collection view needs to be scrolled to where the cell is.
            [self setContentOffset:CGPointMake(0, 0) animated:YES];
        else if (nVisibleRow < ip.row)
            [self setContentOffset:CGPointMake(self.frame.size.width, 0) animated:YES];
    }
    // the data source
    [_items replaceObjectAtIndex:item withObject:[NSNumber numberWithInt:num]];
    // to set the number
    ComposeCell* cell = [_cells objectAtIndex:ip.row]; // invisible celss can't be accessed by index path
    [cell setNumberOfItems:item num:num animated:animated];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
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
        [cell setItems:items offset:range.location];
        // to add the cell
        [_cells addObject:cell];
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
    [_composeCollectionViewDelegate pageWasScrolledTo:nPage];
}

@end
