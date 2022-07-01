//
//  RCRequestCapture.m
//  KEPRequestCapture
//
//  Created by weidianwen on 2022/1/6.
//

#import "RCRequestCapture.h"
#import "RCCustomHTTPProtocol.h"
#import "UIViewController+RC.h"
#import "RCBaseViewController.h"
#import "RCNavigationController.h"
#import "RCRequestsViewController.h"

NSString *const fireWormholy = @"wormholy_fire";
//默认可以摇一摇
static BOOL rc_shakeEnabled = YES;

@implementation RCRequestCapture

+ (void)load {
#if DEBUG || TEST_DEBUG
    NSLog(@"RC - RCRequestCapture Load");
    [[NSNotificationCenter defaultCenter] addObserverForName:@"wormholy_fire" object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [RCRequestCapture presentWormholyFlow];
    }];
    
    [RCRequestCapture openRequestCapture];
#endif
}

#pragma mark - 开启关闭

+ (void)openRequestCapture {
    [NSURLProtocol registerClass:RCCustomHTTPProtocol.class];
}

+ (void)closeRequestCapture {
    [NSURLProtocol unregisterClass:RCCustomHTTPProtocol.class];
}

#pragma mark - 展现界面

+ (void)presentWormholyFlow {
    if ([[UIViewController rc_currentViewController:nil] isKindOfClass:RCBaseViewController.class] || [[UIViewController rc_currentViewController:nil] isKindOfClass:RCNavigationController.class]) {
        return;
    }
    
    RCNavigationController *nav = [[RCNavigationController alloc] initWithRootViewController:[[RCRequestsViewController alloc] init]];
    nav.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [[UIViewController rc_currentViewController:nil] presentViewController:nav animated:YES completion:nil];
}

#pragma mark - 存读方法

+ (NSArray<NSString *> *)ignoredHosts {
    return RCCustomHTTPProtocol.ignoredHosts;
}

+ (void)setIgnoredHosts:(NSArray<NSString *> *)ignoredHosts {
    RCCustomHTTPProtocol.ignoredHosts = ignoredHosts;
}

/* Notice - (啥时候需要再写)
+ (void)setLimit:(NSNumber *)limit {
    [RCStorage sharedInstance].limit = limit;
} */

/* Notice - (啥时候需要再写)
+ (NSNumber *)limit {
    return [RCStorage sharedInstance].limit;
} */

+ (void)setShakeEnabled:(BOOL)shakeEnabled {
    rc_shakeEnabled = shakeEnabled;
}

+ (BOOL)shakeEnabled {
    return rc_shakeEnabled;
}

@end
