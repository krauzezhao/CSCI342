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

// ingredients
static const int NUM_INGREDIENTS = 11;

typedef enum _Ingredient
{
    // placeholder
    I_PH = -1,
    // watch: to slow time
    I_QUARTZ,
    I_HOURHAND,
    I_MINHAND,
    I_SECHAND,
    // powered watch: to stop time
    I_WATCH,
    I_POWERUP,
    // king: to reshuffle letters
    I_SCEPTRE,
    I_CROWN,
    I_THRONE,
    // magnifier: to highlight words
    I_CONVEXLENS,
    I_HANDLE,
}Ingredient;

// formula
static const int NUM_FORMULAS = 4;

typedef enum _FormulaIndex
{
    FI_WATCH = 0,
    FI_PWATCH,
    FI_KING,
    FI_MAGNIFIER
}FormulaIndex;

static const Ingredient FORMULA[NUM_FORMULAS][4] = {
    {I_QUARTZ, I_HOURHAND, I_MINHAND, I_SECHAND}, // watch
    {I_WATCH, I_POWERUP, I_PH, I_PH}, // powered watch
    {I_SCEPTRE, I_CROWN, I_THRONE, I_PH}, // king
    {I_CONVEXLENS, I_HANDLE, I_PH, I_PH} // magnifier
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
