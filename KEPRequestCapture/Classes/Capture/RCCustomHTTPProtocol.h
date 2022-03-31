//
//  RCCustomHTTPProtocol.h
//  Keep
//
//  Created by weidianwen on 2022/1/6.
//  Copyright © 2022 Beijing Calorie Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCCustomHTTPProtocol : NSURLProtocol

/// 需要忽略的域名集合
@property (nonatomic, copy, class) NSArray<NSString *> *ignoredHosts;

@end

NS_ASSUME_NONNULL_END
