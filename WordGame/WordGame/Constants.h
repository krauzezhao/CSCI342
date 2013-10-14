//
//  Constants.h
//  WordGame
//
//  Created by Hong Zhao on 3/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#ifndef WordGame_Constants_h
#define WordGame_Constants_h

static const int SPACE = 0; // the space between the border and the play view

// the level enumeration
typedef enum _Level
{
    LV_MASTER1,
    LV_MASTER2,
    LV_MASTER3
}Level;

// the letter image prefix
typedef  enum _LetterIndex{
    LI_BLACK,
    LI_BLUE,
    LI_DG,
    LI_GOLD,
    LI_GREY,
    LI_LG,
    LI_ORANGE,
    LI_PINK,
    LI_RED,
    LI_VIOLET
}LetterIndex;

static const char* LETTER[] = {
    "black", "blue", "dg", "gold", "grey",
    "lg", "orange", "pink", "red", "violet"
};

// the direction of the brick movement
typedef enum _Direction
{
    D_HORIZONTAL,
    D_VERTICAL
}Direction;

typedef enum _BrickStatus
{
    BS_HIGHLIGHTED,
    BS_UNSELECTED
}BrickStatus;

// ingredients
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

#endif
