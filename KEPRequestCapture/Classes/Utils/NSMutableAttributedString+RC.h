//
//  NSMutableAttributedString+RC.h
//  Keep
//
//  Created by weidianwen on 2022/1/7.
//  Copyright © 2022 Beijing Calorie Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableAttributedString (RC)

- (NSMutableAttributedString *)bold:(NSString *)text;

- (NSMutableAttributedString *)normal:(NSString *)text;

- (NSMutableAttributedString *)chageTextColor:(UIColor *)toColor;

@end

NS_ASSUME_NONNULL_END
