//
//  RCRequestStorage.h
//  KEPRequestCapture
//
//  Created by zhen li on 2022/1/6.
//

#import <Foundation/Foundation.h>
#import "RCRequestModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCRequestStorage : NSObject

+ (instancetype)sharedInstance;

/// 保存请求
/// @param requestModel 请求数据
- (void)saveRequest:(RCRequestModel *)requestModel;

/// 加载所有当前保存的请求
- (NSArray *)loadAllReuestsCache;

/// 清除所有缓存
- (void)clearAllRequestCache;
@end

NS_ASSUME_NONNULL_END
