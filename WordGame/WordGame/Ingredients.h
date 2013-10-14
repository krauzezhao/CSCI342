//
//  Ingredients.h
//  WordGame
//
//  Created by Brendan Dickinson on 14/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Ingredients : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * name;

@end
