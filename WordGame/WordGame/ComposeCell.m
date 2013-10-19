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
        _nNumItems = 0;
    }
    return self;
}

- (void)setItems:(NSMutableArray *)numOfItems
{
    if (_nNumItems != 0)
        return; // to avoid a second set
    // the width of one item
    CGFloat fWidth = self.frame.size.width / NUM_ITEMS_PER_ROW;
    // the item array
    _nNumItems = numOfItems.count;
    _items = [[NSMutableArray alloc] initWithCapacity:_nNumItems];
    for (int i = 0; i < _nNumItems; i++)
    {
        // the coordinate of the item
        int nRow = i / NUM_ITEMS_PER_ROW;
        int nCol = i % NUM_ITEMS_PER_ROW;
        // to initialise the item
        CGRect rcItem = CGRectMake(nCol * fWidth, nRow * fWidth, fWidth, fWidth);
        ItemCell* item = [[ItemCell alloc] initWithFrame:rcItem];
        // the item image
        ItemIndex ii = [[numOfItems objectAtIndex:i] intValue];
        if (ii == II_UNKNOWN)
            [item setImage:[NSString stringWithFormat:@"%s", ITEM_UNKNOWN]];
        else if (ii == II_UNAVAIL)
            [item setImage:[NSString stringWithFormat:@"%s_%s", PREFIX_UNAVAIL, ITEM[i]]];
        else
            [item setImage:[NSString stringWithFormat:@"%s_%s", PREFIX_AVAIL, ITEM[i]]];
        // the item delegate
        item.delegate = _delegate;
        // to add the item
        [_items addObject:item];
        [self addSubview:item];
    }
}

- (BOOL)isSet
{
    return _nNumItems != 0;
}
@end
