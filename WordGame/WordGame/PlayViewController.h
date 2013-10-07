//
//  PlayViewController.h
//  WordGame
//
//  Created by Hong Zhao on 3/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "PlayView.h"

@interface PlayViewController : UIViewController

@property Level level;

@property (weak, nonatomic) IBOutlet PlayView *vPlay;


@end
