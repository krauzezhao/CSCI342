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

///*** CAMBRIDGE DICTIONARY WEB SERVICE ***///
// URL
static NSString* WS_URL = @"https://dictionary.cambridge.org/api/v1/dictionaries/british/search";
//** HTTP HEADER PARAMETERS **//
// accessKey
static NSString* WS_FIELD_KEY = @"accessKey";
static NSString* WS_KEY = @"HslsykNY8sI5Zjxt8UTYSqztTluQr6SmCeFRszPuCM3tQvc0vkM9GAyHPvJJTjyT";
// Accept
static NSString* WS_FIELD_ACCEPT = @"Accept";
static NSString* WS_ACCEPT = @"application/json";
// pageindex
static NSString* WS_FIELD_PAGEINDEX = @"pageindex";
static NSString* WS_PAGEINDEX = @"1";
// pagesize
static NSString* WS_FIELD_PAGESIZE = @"pagesize";
static NSString* WS_PAGESIZE = @"10";
// q: the word to be searched for
//** END OF HTTP HEADER MESSAGE **//
//** JSON RESPONSE **//
static NSString* WS_JSON_RESULT = @"results";
//** END OF JSON RESPONSE **//
///*** END OF WEB SERVICE ***///

// library input type
typedef enum _LibraryInputType
{
    LIT_NAME,
    LIT_WORD
}LibraryInputType;
#endif
