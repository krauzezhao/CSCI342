//
//  Constants.h
//  WordGame
//
//  Created by Hong Zhao on 3/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#ifndef WordGame_Constants_h
#define WordGame_Constants_h

// the level enumeration
typedef enum _Level
{
    LV_MASTER1,
    LV_MASTER2,
    LV_MASTER3
}Level;

// the direction of the brick movvement
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

#endif
