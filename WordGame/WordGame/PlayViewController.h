//
//  PlayViewController.h
//  WordGame
//
//  Created by Hong Zhao on 3/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "Constants.h"
#import "Library.h"
#import "NDTrie.h"
#import "TitleView.h"
#import "PlayView.h"
#import "Word.h"

@interface PlayViewController : UIViewController <LetterSelectionDelegate, TimerDelegate>

@property Level level;
@property (strong, nonatomic) NSManagedObjectContext* moc;
@property (strong, nonatomic) Library* lib;
@property NDMutableTrie* trie;

@property (weak, nonatomic) IBOutlet PlayView *vPlay;
@property (weak, nonatomic) IBOutlet TitleView *tvTitle;

@end
