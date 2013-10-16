//
//  Library.h
//  WordGame
//
//  Created by Brendan Dickinson on 16/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Word;

@interface Library : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * usage;
@property (nonatomic, retain) NSSet *fkLibWords;
@end

@interface Library (CoreDataGeneratedAccessors)

- (void)addFkLibWordsObject:(Word *)value;
- (void)removeFkLibWordsObject:(Word *)value;
- (void)addFkLibWords:(NSSet *)values;
- (void)removeFkLibWords:(NSSet *)values;

@end
