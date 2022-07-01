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
#if DEBUG || TEST_DEBUG
    NSLog(@"RC - NSURLSessionConfiguration Load");
    [[self class] rc_swizzleClassMethodWithOriginSel:@selector(defaultSessionConfiguration) swizzledSel:@selector(rc_defaultSessionConfiguration)];
    [[self class] rc_swizzleClassMethodWithOriginSel:@selector(ephemeralSessionConfiguration) swizzledSel:@selector(rc_ephemeralSessionConfiguration)];
#endif
}

+ (NSURLSessionConfiguration *)rc_defaultSessionConfiguration{
    NSURLSessionConfiguration *configuration = [self rc_defaultSessionConfiguration];
    [configuration rc_addDoraemonNSURLProtocol];
    return configuration;
}

+ (NSURLSessionConfiguration *)rc_ephemeralSessionConfiguration{
    NSURLSessionConfiguration *configuration = [self rc_ephemeralSessionConfiguration];
    [configuration rc_addDoraemonNSURLProtocol];
    return configuration;
}

- (void)rc_addDoraemonNSURLProtocol {
    NSLog(@"RC - NSURLSessionConfiguration addDoraemonNSURLProtocol");
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
