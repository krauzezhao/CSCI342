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
    }
    return self;
}

- (void)setNumberOfItems:(int)num
{
    _nNumItems = num;
    [self layoutItems];
}

///*** PRIVATE ***///
- (void)layoutItems
{
    // the width of one item
    CGFloat fWidth = self.frame.size.width / NUM_ITEMS_PER_ROW;
    // the item array
    _items = [[NSMutableArray alloc] initWithCapacity:_nNumItems];
    for (int i = 0; i < _nNumItems; i++)
    {
        // the coordinate of the item
        int nRow = i / NUM_ITEMS_PER_ROW;
        int nCol = i % NUM_ITEMS_PER_ROW;
        // to initialise the item
        CGRect rcItem = CGRectMake(nCol * fWidth, nRow * fWidth, fWidth, fWidth);
        ItemCell* item = [[ItemCell alloc] initWithFrame:rcItem];
        // the item delegate
        item.delegate = _delegate;
        // to add the item
        [_items addObject:item];
        [self addSubview:item];
    }
}
///*** END OF PRIVATE ***///
@end
