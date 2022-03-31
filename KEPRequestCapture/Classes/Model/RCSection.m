//
//  RCSection.m
//  Keep
//
//  Created by weidianwen on 2022/1/7.
//  Copyright © 2022 Beijing Calorie Technology Co., Ltd. All rights reserved.
//

#import "RCSection.h"

@implementation RCSection

- (instancetype)initWithName:(NSString *)name type:(RCSectionType)type {
    if (self = [super init]) {
        self.name = name;
        self.type = type;
    }
    
    return self;
}

@end
