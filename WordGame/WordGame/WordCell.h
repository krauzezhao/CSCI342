//
//  WordCell.h
//  WordGame
//
//  Created by Brendan Dickinson on 16/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

static const int PADDING_HORIZONTAL = 5;
static const int PADDING_VERTICAL = 1;
static const float PERCENTAGE_WIDTH_TITLE = .7;

@interface WordCell : UITableViewCell

///*** PRIVATE ***///
@property (strong, nonatomic) UILabel* lblTitle;
@property (strong, nonatomic) UILabel* lblInfoTitle;
@property (strong, nonatomic) UILabel* lblSubtitleLeft;
@property (strong, nonatomic) UILabel* lblSubtitleRight;
///*** END OF PRIVATE ***///

- (void)setTitle:(NSString*)title;
- (void)setInfoTitle:(NSString*)info;
- (void)setSubtitleLeft:(NSString*)subtitle;
- (void)setSubtitleRight:(NSString*)subtitle;

///*** PRIVATE ***///
// init
- (void)initTitle;
- (void)initInfoTitle;
- (void)initSubtitleLeft;
- (void)initSubtitleRight;
///*** END OF PRIVATE ***///

@end
