//
//  ItemDropModel.m
//  WordGame
//
//  Created by Brendan Dickinson on 19/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import "ItemDropModel.h"

@implementation ItemDropModel

- (id)init:(int)dropRateFactor
{
    if (self = [super init])
    {
        srand(time(NULL));
        _dropRateFactor = dropRateFactor;
        // to initialise the drop table
        _dropTable = [[NSMutableArray alloc] init];
        int nPrev = 1;
        [_dropTable addObject:[NSNumber numberWithInt:nPrev]];
        for (int i = 1; i < NUM_ITEMS + 1; i++)
        {
            nPrev = [[_dropTable lastObject] intValue];
            [_dropTable addObject:[NSNumber numberWithInt:nPrev + DROPRATE_ITEM[i - 1]]];
        }
    }
    return self;
}

- (ItemIndex)dropAnItem
{
    int nIndex = II_NULL;
    int n = rand() % _dropRateFactor + 1;
    for (int i = 0; i < NUM_ITEMS; i++)
    {
        int nIndexStart = [[_dropTable objectAtIndex:i] intValue];
        int nIndexEnd = [[_dropTable objectAtIndex:i + 1] intValue];
        if (n >= nIndexStart && n < nIndexEnd)
        {
            nIndex = i;
            break;
        }
    }
    return nIndex;
}
@end
