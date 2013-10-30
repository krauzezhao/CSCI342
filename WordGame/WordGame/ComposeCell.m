//
//  ComposeCell.m
//  WordGame
//
//  Created by Brendan Dickinson on 18/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import "ComposeCell.h"

@implementation ComposeCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        self.backgroundColor = [UIColor clearColor];
        _numberOfItems = 0;
    }
    return self;
}

- (void)setItems:(NSMutableArray *)numOfItems offset:(int)offset
{
    if (_numberOfItems != 0)
        return; // to avoid a second set
    // the width of one item
    CGFloat fWidth = self.frame.size.width / NUM_ITEMS_PER_ROW;
    // the item array
    _numberOfItems = numOfItems.count;
    _items = [[NSMutableArray alloc] initWithCapacity:_numberOfItems];
    for (int i = 0; i < _numberOfItems; i++)
    {
        // the coordinate of the item
        int nRow = i / NUM_ITEMS_PER_ROW;
        int nCol = i % NUM_ITEMS_PER_ROW;
        // to initialise the item
        CGRect rcItem = CGRectMake(nCol * fWidth, nRow * fWidth, fWidth, fWidth);
        ItemCell* item = [[ItemCell alloc] initWithFrame:rcItem];
        // the item image
        ItemIndex ii = [[numOfItems objectAtIndex:i] intValue];
        [item setItem:i + offset number:ii];
        item.tag = i + offset; // The tag is the item index.
        // the item delegate
        item.delegate = _delegate;
        // to add the item
        [_items addObject:item];
        [self addSubview:item];
    }
}

- (BOOL)isSet
{
    return _numberOfItems != 0;
}

- (void)setNumberOfItems:(ItemIndex)item num:(int)num animated:(BOOL)animated
{
    // to compute the offset
    ItemCell* cell = [_items objectAtIndex:0];
    int nOffset = cell.tag;
    // to find the cell that holds the specified item
    cell = [_items objectAtIndex:item - nOffset];
    [cell setItem:item number:num];
    // to highlight the item
    if (animated)
        [cell highlight];
}
@end
