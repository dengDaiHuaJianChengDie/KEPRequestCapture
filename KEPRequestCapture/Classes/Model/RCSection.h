//
//  RCSection.h
//  Keep
//
//  Created by weidianwen on 2022/1/7.
//  Copyright © 2022 Beijing Calorie Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, RCSectionType) {
    RCSectionTypeOverview,
    RCSectionTypeRequestHeader,
    RCSectionTypeRequestBody,
    RCSectionTypeResponseHeader,
    RCSectionTypeResponseBody,
};

NS_ASSUME_NONNULL_BEGIN

@interface RCSection : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) RCSectionType type;

- (instancetype)initWithName:(NSString *)name type:(RCSectionType)type;

@end

NS_ASSUME_NONNULL_END
