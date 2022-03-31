//
//  RCRequestCapture.h
//  KEPRequestCapture
//
//  Created by weidianwen on 2022/1/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN NSString *const fireWormholy;

@interface RCRequestCapture : NSObject

/// 需要忽略的域名集合
@property (nonatomic, copy, class) NSArray<NSString *> *ignoredHosts;
/// 存放条数限制
//@property (nonatomic, strong, class) NSNumber *limit;
/// 是否允许摇一摇
@property (nonatomic, assign, class) BOOL shakeEnabled;

+ (void)openRequestCapture;

+ (void)closeRequestCapture;

@end

NS_ASSUME_NONNULL_END
