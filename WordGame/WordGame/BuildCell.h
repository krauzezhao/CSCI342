//
//  BuildCell.h
//  WordGame
//
//  Created by Brendan Dickinson on 14/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuildCell : UITableViewCell

@property (strong, nonatomic) UITextField* tfInput;

- (void)setAsLibraryName;
- (void)setAsWord;

@end
