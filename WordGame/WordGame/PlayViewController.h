//
//  PlayViewController.h
//  WordGame
//
//  Created by Hong Zhao on 3/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "TitleView.h"
#import "PlayView.h"

@interface PlayViewController : UIViewController <LetterSelectionDelegate>

@property Level level;

@property (weak, nonatomic) IBOutlet PlayView *vPlay;
@property (weak, nonatomic) IBOutlet TitleView *tvTitle;


@end
