//
//  RCBaseViewController.h
//  Keep
//
//  Created by weidianwen on 2022/1/6.
//  Copyright © 2022 Beijing Calorie Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCBaseViewController : UIViewController

/// 展示加载视图
- (UIView *)showLoader:(UIView *)view;

/// 隐藏加载视图
- (void)hideLoader:(UIView *)loaderView;

@end

NS_ASSUME_NONNULL_END
