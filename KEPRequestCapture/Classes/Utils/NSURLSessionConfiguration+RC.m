//
//  NSURLSessionConfiguration+RC.m
//  Keep
//
//  Created by weidianwen on 2022/1/7.
//  Copyright © 2022 Beijing Calorie Technology Co., Ltd. All rights reserved.
//

#import "NSURLSessionConfiguration+RC.h"
#import "NSObject+RC.h"
#import "RCCustomHTTPProtocol.h"

@implementation NSURLSessionConfiguration (RC)

+ (void)load{
#ifdef DEBUG
    NSLog(@"RC - NSURLSessionConfiguration Load");
    [[self class] rc_swizzleClassMethodWithOriginSel:@selector(defaultSessionConfiguration) swizzledSel:@selector(wormholy_defaultSessionConfiguration)];
    [[self class] rc_swizzleClassMethodWithOriginSel:@selector(ephemeralSessionConfiguration) swizzledSel:@selector(wormholy_ephemeralSessionConfiguration)];
#endif
}

+ (NSURLSessionConfiguration *)wormholy_defaultSessionConfiguration{
    NSURLSessionConfiguration *configuration = [self wormholy_defaultSessionConfiguration];
    [configuration addDoraemonNSURLProtocol];
    return configuration;
}

+ (NSURLSessionConfiguration *)wormholy_ephemeralSessionConfiguration{
    NSURLSessionConfiguration *configuration = [self wormholy_ephemeralSessionConfiguration];
    [configuration addDoraemonNSURLProtocol];
    return configuration;
}

- (void)addDoraemonNSURLProtocol {
    if ([self respondsToSelector:@selector(protocolClasses)]
        && [self respondsToSelector:@selector(setProtocolClasses:)]) {
        NSMutableArray * urlProtocolClasses = [NSMutableArray arrayWithArray: self.protocolClasses];
        Class protoCls = RCCustomHTTPProtocol.class;
        if (![urlProtocolClasses containsObject:protoCls]) {
            [urlProtocolClasses insertObject:protoCls atIndex:0];
        }
        self.protocolClasses = urlProtocolClasses;
    }
}


@end
