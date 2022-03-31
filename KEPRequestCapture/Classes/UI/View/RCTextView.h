//
//  RCTextView.h
//  Keep
//
//  Created by weidianwen on 2022/1/7.
//  Copyright © 2022 Beijing Calorie Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCTextView : UITextView

- (NSMutableArray<NSTextCheckingResult *> *)highlights:(NSString *)text
                                                 color:(UIColor *)color
                                                  font:(UIFont *)font
                                       highlightedFont:(UIFont *)highlightedFont;

- (nullable UITextRange *)convertRange:(NSRange)range;

@end

NS_ASSUME_NONNULL_END
