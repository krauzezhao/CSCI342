//
//  Player.m
//  WordGame
//
//  Created by Brendan Dickinson on 19/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import "Player.h"


@implementation Player

@dynamic experience;
@dynamic items;
@dynamic level;

@end

@implementation items

+ (Class)transformedValueClass
{
    return [NSMutableArray class];
}

+ (BOOL)allowsReverseTransformation
{
    return YES;
}

- (id)transformedValue:(id)value
{
    return [NSKeyedArchiver archivedDataWithRootObject:value];
}

- (id)reverseTransformedValue:(id)value
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:value];
}

@end