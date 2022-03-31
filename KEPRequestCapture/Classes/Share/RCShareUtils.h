//
//  RCShareUtils.h
//  Keep
//
//  Created by weidianwen on 2022/1/7.
//  Copyright © 2022 Beijing Calorie Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCRequestModelBeautifier.h"
#import "RCRequestModel.h"
#import "NSMutableAttributedString+RC.h"
#import "NSDictionary+RC.h"
#import "NSString+RC.h"
#import "RCCustomActivity.h"
#import "RCFileHandler.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCShareUtils : NSObject

+ (void)shareRequests:(UIViewController *)presentingViewController
               sender:(UIBarButtonItem *)sender
             requests:(NSArray *)requests
  requestExportOption:(RCRequestResponseExportOption)requestExportOption;

+ (NSString *)getTxtText:(NSArray<RCRequestModel *> *)requests;
+ (NSString *)getCurlText:(NSArray<RCRequestModel *> *)requests;

@end

NS_ASSUME_NONNULL_END
