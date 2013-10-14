//
//  Dictionary.h
//  WordGame
//
//  Created by Brendan Dickinson on 14/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Dictionary : NSManagedObject

@property (nonatomic, retain) NSString * definition;
@property (nonatomic, retain) NSString * word;

@end
