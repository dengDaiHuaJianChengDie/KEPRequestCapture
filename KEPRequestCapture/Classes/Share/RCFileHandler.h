//
//  RCFileHandler.h
//  Keep
//
//  Created by weidianwen on 2022/1/7.
//  Copyright © 2022 Beijing Calorie Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCFileHandler : NSObject

+ (void)writeTxtFile:(NSString *)text path:(NSString *)path;
+ (void)writeTxtFileOnDesktop:(NSString *)text fileName:(NSString *)fileName;

@end

NS_ASSUME_NONNULL_END
