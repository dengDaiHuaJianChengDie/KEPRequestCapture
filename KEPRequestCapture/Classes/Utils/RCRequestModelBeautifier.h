//
//  RCRequestModelBeautifier.h
//  Keep
//
//  Created by weidianwen on 2022/1/7.
//  Copyright © 2022 Beijing Calorie Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCRequestModel.h"

typedef NS_ENUM(NSUInteger, RCRequestResponseExportOption) {
    RCRequestResponseExportOptionFlat,
    RCRequestResponseExportOptionCurl,
    RCRequestResponseExportOptionPostman,
};

NS_ASSUME_NONNULL_BEGIN

@interface RCRequestModelBeautifier : NSObject

+ (NSMutableAttributedString *)overview:(RCRequestModel *)request;
+ (NSString *)stringWithDate:(NSDate *)date;
+ (NSDateFormatter *)defaultDateFormatter;
+ (NSMutableAttributedString *)header:(NSDictionary<NSString *, NSString *> *)headers;
+ (NSString *)body:(NSData *)body splitLength:(NSInteger)splitLength;
+ (void)body:(NSData *)body splitLength:(NSInteger)splitLength completion:(void (^)(NSString *))completion;
+ (NSString *)txtExport:(RCRequestModel *)request;
+ (NSString *)curlExport:(RCRequestModel *)request;

@end

NS_ASSUME_NONNULL_END
