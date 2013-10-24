//
//  ItemDropModel.h
//  WordGame
//
//  Created by Brendan Dickinson on 19/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <stdlib.h>
#import "Item.h"

// indexed by level number
static const int DROP_RATE_FACTOR[] = {
    450, 270, 120
};

@interface ItemDropModel : NSObject

///*** PRIVATE ***///
// the drop rate factor
@property int nDropRateFactor;
// to record the random number range within which a particular item can drop
@property (strong, nonatomic) NSMutableArray* dropTable;
///*** END OF PRIVATE ***///

- (id)init:(int)dropRateFactor;
- (ItemIndex)dropAnItem;

@end
