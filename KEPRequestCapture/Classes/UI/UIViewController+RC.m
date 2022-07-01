//
//  UIViewController+RC.m
//  Keep
//
//  Created by weidianwen on 2022/1/6.
//  Copyright © 2022 Beijing Calorie Technology Co., Ltd. All rights reserved.
//

#import "UIViewController+RC.h"
#import "RCRequestCapture.h"

@implementation UIViewController (RC)

+ (nullable UIViewController *)rc_currentViewController:(nullable UIViewController *)viewController {
    if (viewController == nil) {
        viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        if (viewController == nil) {
            return nil;
        }
    }
    
    if ([viewController isKindOfClass:UINavigationController.class]) {
        UINavigationController *naviVC = (UINavigationController *)viewController;
        if (naviVC.visibleViewController) {
            return [self rc_currentViewController:naviVC.visibleViewController];
        } else {
            return [self rc_currentViewController:naviVC.topViewController];
        }
    } else if ([viewController isKindOfClass:UITabBarController.class]) {
        UITabBarController *tabBarVC = (UITabBarController *)viewController;
        if (tabBarVC.viewControllers.count > 5 && tabBarVC.selectedIndex >= 4) {
            return [self rc_currentViewController:tabBarVC.moreNavigationController];
        } else {
            return [self rc_currentViewController:tabBarVC.selectedViewController];
        }
    } else if (viewController.presentedViewController) {
        return [self rc_currentViewController:viewController.presentedViewController];
    } else if (viewController.childViewControllers.count > 0) {
        return viewController.childViewControllers.firstObject;
    } else {
        return viewController;
    }
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake && RCRequestCapture.shakeEnabled) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"wormholy_fire" object:nil];
    }
    
    [self.nextResponder motionBegan:motion withEvent:event];
}

@end
