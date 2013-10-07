//
//  Spells.h
//  WordGame
//
//  Created by Hong Zhao on 7/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Spells : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) id ingredients;

@end

// tranformable field
@interface ingredients : NSValueTransformer
@end