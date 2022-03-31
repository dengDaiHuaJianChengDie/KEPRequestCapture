//
//  RCRequestModel.h
//  KEPRequestCapture
//
//  Created by weidianwen on 2022/1/6.
//

#import <Foundation/Foundation.h>

@import JSONModel;

NS_ASSUME_NONNULL_BEGIN
@interface RCRequestModel : JSONModel

/// UUID
@property (nonatomic, copy) NSString *uuid;
/// 请求路径
@property (nonatomic, copy) NSString *url;
/// 请求路径域名
@property (nonatomic, copy) NSString *host;
/// 请求路径端口
@property (nonatomic, copy) NSNumber *port;
/// 请求路径路由
@property (nonatomic, copy) NSString *scheme;

/// 请求时间
@property (nonatomic, strong) NSDate *date;
/// 请求类型（GET、POST等）
@property (nonatomic, copy) NSString *method;
/// 请求响应时长
@property (nonatomic, assign) double duration;
/// 响应结果码
@property (nonatomic, assign) NSInteger code;

/// 身份认证信息
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> *credentials;
/// 请求头信息
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> *headers;
/// 响应头信息
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> *responseHeaders;

/// 请求 cookies 信息
@property (nonatomic, copy) NSString *cookies;
/// 请求响应 body 信息
@property (nonatomic, strong) NSData *httpBody;

/// 响应结果数据
@property (nonatomic, strong) NSMutableData *dataResponse;
/// 失败信息描述
@property (nonatomic, copy) NSString *errorClientDescription;


/// 初始化方法
/// @param request 任务 request
/// @param session 任务 session
- (instancetype)initWithRequest:(NSURLRequest *)request session:(NSURLSession *)session;

/// 初始化方法
/// @param response 响应结果
- (instancetype)initWithResponse:(NSURLResponse *)response;

/// 构建传输路径方法
- (NSString *)curlRequest;

/// 设置响应结果数据方法
/// @param response 响应结果
- (void)setupResponse:(NSURLResponse *)response;

@end

NS_ASSUME_NONNULL_END
