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
// item type
typedef enum _ItemType
{
    IT_ITEM,
    IT_SCROLL,
    IT_NULL // not an item
}ItemType;

// items
static const int NUM_ITEMS = 18;

typedef enum _ItemIndex
{
    II_NULL = -3, // no loot
    II_UNKNOWN, // The user has not found this item
    II_UNAVAIL, // when the user used up an item
    II_SCROLL_WATCH,
    II_SCROLL_POWEREDWATCH,
    II_SCROLL_KING,
    II_SCROLL_MAGNIFIER,
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
    "scroll_watch.png",
    "scroll_poweredwatch.png",
    "scroll_king.png",
    "scroll_magnifier.png",
    "king.png", "magnifier.png", "poweredwatch.png",
    "convexlens.png", "crown.png", "handle.png",
    "hourhand.png", "minhand.png", "powerup.png",
    "quartz.png", "sceptre.png", "sechand.png",
    "throne.png", "watch.png"
};

// measured in 100
static const int DROPRATE_ITEM[] = {
    3, 4, 8, 2,
    1, 1, 1, // Usable items rarely drop.
    5, 1, 5,
    5, 5, 3,
    5, 1, 1,
    7, 1
};

__unused static const char* ITEM_UNKNOWN = {"unknown.png"};

// scrolls
// the formula
// indexed by ScrollIndex
// sorted by ItemIndex
static const ItemIndex FORMULA_WATCH[] = {II_HOURHAND, II_MINHAND, II_QUARTZ, II_SECHAND};
static const ItemIndex FORMULA_POWEREDWATCH[] = {II_POWERUP, II_WATCH};
static const ItemIndex FORMULA_KING[] = {II_CROWN, II_SCEPTRE, II_THRONE};
static const ItemIndex FORMULA_MAGNIFIER[] = {II_CONVEXLENS, II_HANDLE};

__unused static const ItemIndex* FORMULA[] = {
    FORMULA_WATCH, FORMULA_POWEREDWATCH, FORMULA_KING, FORMULA_MAGNIFIER
};

// the final composition of each formula
__unused static const ItemIndex FORMULA_COMPOSITION[] = {
    II_WATCH, II_POWEREDWATCH, II_KING, II_MAGNIFIER
};

// the number of items in each formula
static const int FORMULA_NUM_ITEMS[] = {
    4, 2, 3, 2
};

// usable items that can be used during a gameplay
// indexed by ScrollIndex
static const int NUM_USABLE = 4;

__unused static const ItemIndex USABLE_INDEX[] = {
    II_WATCH, II_POWEREDWATCH, II_KING, II_MAGNIFIER
};

__unused static const char* USABLE[] = {
    "watch.png",
    "poweredwatch.png",
    "king.png",
    "magnifier.png"
};

// item names
// indexed by the item index
__unused static const char* ITEM_NAME[] = {
    "Scroll Of Winter Ice",
    "Scroll of the Arctic Ice",
    "Scroll of Shuffling Deck",
    "Scroll of The Magnified Eye",
    "Shuffling Deck",
    "Magnified Eye",
    "Arctic Ice",
    "Eyeglass of the Learned",
    "Crown of the High Priest",
    "Torch of the Pitted Cave",
    "Broadsword of Barbarians",
    "Dagger of the Dwarvin Rogue",
    "Corge of the Time Machine",
    "Jewels of the Princess",
    "Sceptor of the Sorceress",
    "Broom of the Witch",
    "Mass Grave of the Scar",
    "Winter Ice"
};

// item descriptions
// indexed by the item index
__unused static const char* ITEM_DESCRIPTION[] = {
    "This is the formula to combined with ingredients to produce a powerup that gives the player a one time ability to freeze time for 5 seconds.",
    "This is a powerful formula that is used to combine with rare ingredients to conjure a powerful powerup that gives the player a one time ability to adds (number of seconds) to the countdown and freezes it for 15 seconds.",
    "This is the formula used to create a powerup that gives the player a one time ability to reshuffle the grid to give them a fresh perspective.",
    "This is the formula used to create a powerup that gives the player a one time ability to highlight letters  allowing the player to easily select and form a word from their library",
    "This powerup gives the player a one time ability to reshuffle the puzzle to give a fresh view of the game.",
    "This powerup gives the player a one time ability to highlight the letters of the words.",
    "This powerful powerUp gives the player a one time ability to increase the time by (number) seconds and freezes (number) seconds to the countdown time.",
    "Politicians who woo nations with their speech each had worn this eyeware to influence their followers subconsciously.",
    "Once the symbol of unity and religion, now it is used in rituals to summon celestial spirits to assist in formulation of powerful spells.",
    "Many heroes of the past would not had had the chance to tell their story if they had not have this torch to find their way back out whilst battling demons underground.",
    "Vicious northen barbarians who had conquered unknown territories had each carried this huge weapon.",
    "Seathed in their belt for securities and jobs, these dagger had only seen the light when deemed necessary.",
    "Engineers of the future had learned to adapt to living in the current time due to loosing this item to a devious burglar who smuggled this rare item into the underground market for a handsome sum of gold.",
    "A not so pretty princess had promised to give to her rescuer anything he wanted, instead of asking for her hand, he only wanted this 2kg pink diamond.",
    "Evil and seductive, these unrighteous sorceress used these weapons to wield kings and men to their dark heart desires.",
    "The dark age had brought about the fear of witchcraft bringing about the crackdown on people who practice it. What remains of these individuals are their brooms left untouched until now.",
    "This item carries an eerie scent of blood and gore, repulsive but necessary to formulate spells that redefine the environment.",
    "Formed from the 4 common ingredients gives a unique effect, when combined with a certain rare incredient, it can create a rare unique powerful spell that can gives the player more time to find more words."
};

#endif
