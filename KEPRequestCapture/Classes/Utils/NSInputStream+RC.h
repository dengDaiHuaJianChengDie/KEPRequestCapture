//
//  NSInputStream+RC.h
//  Keep
//
//  Created by weidianwen on 2022/1/6.
//  Copyright © 2022 Beijing Calorie Technology Co., Ltd. All rights reserved.
//  用于处理转化 body 内容

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSInputStream (RC)

- (NSData *)readfully;

@end

NS_ASSUME_NONNULL_END
