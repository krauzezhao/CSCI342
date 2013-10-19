//
//  Item.h
//  WordGame
//
//  Created by Brendan Dickinson on 19/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#ifndef WordGame_Item_h
#define WordGame_Item_h

__unused static const char* PREFIX_AVAIL = "avail_";
__unused static const char* PREFIX_UNAVAIL = "unavail_";

// items
static const int NUM_ITEMS = 14;

typedef enum _ItemIndex
{
    II_UNKNOWN = -2, // The use has not found this item
    II_UNAVAIL, // when the user used up an item
    II_KING,
    II_MAGNIFIER,
    II_POWEREDWATCH,
    II_CONVEXLENS,
    II_CROWN,
    II_HANDLE,
    II_HOURHAND,
    II_MINHAND,
    II_POWERUP,
    II_QUARTZ,
    II_SCEPTRE,
    II_SECHAND,
    II_THRONE,
    II_WATCH
}ItemIndex;

__unused static const char* ITEM[] = {
    "king.png", "magnifier.png", "poweredwatch.png",
    "convexlens.png", "crown.png", "handle.png",
    "hourhand.png", "minhand.png", "powerup.png",
    "quartz.png", "sceptre.png", "sechand.png",
    "throne.png", "watch.png"
};

__unused static const char* ITEM_UNKNOWN = {"unknown.png"};

// scrolls
static const int NUM_SCROLLS = 4;

typedef enum _ScrollIndex
{
    SI_WATCH,
    SI_POWEREDWATCH,
    SI_KING,
    SI_MAGNIFIER
}ScrollIndex;

__unused static const char* SCROLL[] = {
    "scroll_watch.png",
    "scroll_poweredwatch.png",
    "scroll_king.png",
    "scroll_magnifier.png"
};

// the formula
// indexed by ScrollIndex
// sorted by ItemIndex
static const ItemIndex FORMULA_WATCH[] = {II_HOURHAND, II_MINHAND, II_QUARTZ, II_SECHAND};
static const ItemIndex FORMULA_POWEREDWATCH[] = {II_POWERUP, II_WATCH};
static const ItemIndex FORMULA_KING[] = {II_CROWN, II_SCEPTRE, II_THRONE};
static const ItemIndex FORMULA_MAGNIFIER[] = {II_CONVEXLENS, II_HANDLE};

// usable items that can be used during a gameplay
// indexed by ScrollIndex
//static const int NUM_USABLE = 4;

//typedef enum _UsableIndex
//{
//    UI_WATCH,
//    UI_POWEREDWATCH,
//    UI_KING,
//    UI_MAGNIFIER
//}UsableIndex;

__unused static const char* USABLE[] = {
    "watch.png",
    "poweredwatch.png",
    "king.png",
    "magnifier.png"
};

#endif
