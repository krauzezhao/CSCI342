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

@protocol WordCellDelegate <NSObject>

@required
- (void)detailWasTapped;
- (void)deleteWasTapped;

@end

@interface WordCell : UITableViewCell

@property (strong, nonatomic) id<WordCellDelegate> delegate;

///*** PRIVATE ***///
@property (strong, nonatomic) UILabel* lblTitle;
@property (strong, nonatomic) UILabel* lblInfoTitle;
@property (strong, nonatomic) UILabel* lblSubtitle;
@property (strong, nonatomic) UIButton* btnDetail;
@property (strong, nonatomic) UIButton* btnDel;
///*** END OF PRIVATE ***///

- (void)setTitle:(NSString*)title;
- (void)setInfoTitle:(NSString*)info;
- (void)setSubtitle:(NSString*)subtitle;

///*** PRIVATE ***///
// init
- (void)initTitle;
- (void)initInfoTitle;
- (void)initSubtitle;
// accessory buttons config
- (void)configureDetailButton;
- (void)configureDeleteButton;
// events
- (void)detailWasTapped;
- (void)deleteWasTapped;
- (void)cellWasSwipedOverFromRightToLeft:(UISwipeGestureRecognizer*)sgr;
- (void)cellWasSwipedOverFromLeftToRight:(UISwipeGestureRecognizer *)sgr;
///*** END OF PRIVATE ***///

@end
