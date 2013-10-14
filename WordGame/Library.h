//
//  Library.h
//  WordGame
//
//  Created by Brendan Dickinson on 14/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Dictionary;

@interface Library : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *fkLibDict;
@end

@interface Library (CoreDataGeneratedAccessors)

- (void)addFkLibDictObject:(Dictionary *)value;
- (void)removeFkLibDictObject:(Dictionary *)value;
- (void)addFkLibDict:(NSSet *)values;
- (void)removeFkLibDict:(NSSet *)values;

@end
