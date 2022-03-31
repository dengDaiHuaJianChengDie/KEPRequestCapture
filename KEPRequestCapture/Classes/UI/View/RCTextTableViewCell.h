//
//  RCTextTableViewCell.h
//  Keep
//
//  Created by weidianwen on 2022/1/7.
//  Copyright © 2022 Beijing Calorie Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCTextView.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCTextTableViewCell : UITableViewCell

@property (nonatomic, strong) RCTextView *textView;

@end

NS_ASSUME_NONNULL_END
