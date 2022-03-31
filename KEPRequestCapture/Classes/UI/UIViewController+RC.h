//
//  UIViewController+RC.h
//  Keep
//
//  Created by weidianwen on 2022/1/6.
//  Copyright © 2022 Beijing Calorie Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (RC)

+ (nullable UIViewController *)currentViewController:(nullable UIViewController *)viewController;

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event;

@end

NS_ASSUME_NONNULL_END
