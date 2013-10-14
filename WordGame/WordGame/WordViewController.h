//
//  WordViewController.h
//  WordGame
//
//  Created by Brendan Dickinson on 14/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface WordViewController : UIViewController <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

// to receive the selected word from segue
@property (strong, nonatomic) NSString* strWord;

@end
