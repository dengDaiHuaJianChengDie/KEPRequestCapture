//
//  NSString+RC.h
//  Keep
//
//  Created by weidianwen on 2022/1/6.
//  Copyright © 2022 Beijing Calorie Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (RC)

- (NSString *)rc_prettyPrintedJSON;
+ (NSString *)rc_formattedMilliseconds:(double)rounded;

@end

NS_ASSUME_NONNULL_END
