//
//  Player.h
//  WordGame
//
//  Created by Brendan Dickinson on 14/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Player : NSManagedObject

@property (nonatomic, retain) NSNumber * experience;
@property (nonatomic, retain) id ingredients;
@property (nonatomic, retain) NSNumber * level;
@property (nonatomic, retain) id spells;

@end