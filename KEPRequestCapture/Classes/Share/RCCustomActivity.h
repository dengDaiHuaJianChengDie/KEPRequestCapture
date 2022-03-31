//
//  RCCustomActivity.h
//  Keep
//
//  Created by weidianwen on 2022/1/7.
//  Copyright © 2022 Beijing Calorie Technology Co., Ltd. All rights reserved.
//  原生分享工具

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCCustomActivity : UIActivity

- (instancetype)initWithTitle:(NSString *)title image:(UIImage * _Nullable)image performAction:(void (^)(NSArray *))performAction;

@end

NS_ASSUME_NONNULL_END
