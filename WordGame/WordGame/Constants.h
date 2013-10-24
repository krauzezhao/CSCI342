//
//  Constants.h
//  WordGame
//
//  Created by Hong Zhao on 3/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#ifndef WordGame_Constants_h
#define WordGame_Constants_h

#import <Foundation/Foundation.h>

// the max level
static const int MAX_LEVEL = 3;

// the experience needed to reach a particular level
static const int LEVEL_THRESHOLD[] = {
    0, 1500, 4000
};

// library input type
typedef enum _LibraryInputType
{
    LIT_NAME,
    LIT_WORD
}LibraryInputType;
#endif
