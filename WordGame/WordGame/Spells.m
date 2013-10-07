//
//  Spells.m
//  WordGame
//
//  Created by Hong Zhao on 7/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import "Spells.h"


@implementation Spells

@dynamic id;
@dynamic name;
@dynamic ingredients;

@end

// transformable field
@implementation ingredients

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