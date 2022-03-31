//
//  RCBodyDetailViewController.h
//  Keep
//
//  Created by weidianwen on 2022/1/7.
//  Copyright © 2022 Beijing Calorie Technology Co., Ltd. All rights reserved.
//

#import "RCBaseViewController.h"
#import "RCTextView.h"

static CGFloat rcPadding = 10.0;

NS_ASSUME_NONNULL_BEGIN

@interface RCBodyDetailViewController : RCBaseViewController

@property (nonatomic, strong) UIView *toolBar;
@property (nonatomic, strong) UILabel *labelWordFinded;
@property (nonatomic, strong) UIButton *buttonPrevious;
@property (nonatomic, strong) UIButton *buttonNext;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) RCTextView *textView;

@property (nonatomic, strong) NSMutableArray<NSTextCheckingResult *> *highlightedWords;
@property (nonatomic, strong) NSData *data;
@property (nonatomic, assign) NSInteger indexOfWord;

@end

NS_ASSUME_NONNULL_END
