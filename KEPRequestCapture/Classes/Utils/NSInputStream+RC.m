//
//  NSInputStream+RC.m
//  Keep
//
//  Created by weidianwen on 2022/1/6.
//  Copyright © 2022 Beijing Calorie Technology Co., Ltd. All rights reserved.
//

#import "NSInputStream+RC.h"

@implementation NSInputStream (RC)

- (NSData *)readfully {
    NSMutableData *result = [NSMutableData data];
    uint8_t buffer[4096] = {0};
    
    [self open];
    NSInteger amount = 0;
    do {
        amount = [self read:buffer maxLength:4096];
        if (amount > 0) {
            NSData *data = [NSData dataWithBytes:buffer length:amount];
            [result appendData:data];
        }
    } while (amount > 0);
    
    [self close];
    
    return result;
}

@end