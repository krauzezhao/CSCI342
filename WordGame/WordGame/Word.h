//
//  Word.h
//  WordGame
//
//  Created by Brendan Dickinson on 16/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Library;

@interface Word : NSManagedObject

@property (nonatomic, retain) NSString * definition;
@property (nonatomic, retain) NSString * word;
@property (nonatomic, retain) NSNumber * hits;
@property (nonatomic, retain) Library *fkWordLib;

@end
