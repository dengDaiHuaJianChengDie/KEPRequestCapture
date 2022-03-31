//
//  RCCustomHTTPProtocol.m
//  Keep
//
//  Created by weidianwen on 2022/1/6.
//  Copyright © 2022 Beijing Calorie Technology Co., Ltd. All rights reserved.
//

#import "RCCustomHTTPProtocol.h"
#import "RCRequestModel.h"
#import "RCRequestStorage.h"
#import "NSInputStream+RC.h"

static NSArray<NSString *> *_ignoredHosts;

@interface RCCustomHTTPProtocol () <NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURLSessionDataTask *sessionTask;
@property (nonatomic, strong) RCRequestModel *currentRequest;

@end

@implementation RCCustomHTTPProtocol

#pragma mark - 初始化方法

- (instancetype)initWithRequest:(NSURLRequest *)request cachedResponse:(NSCachedURLResponse *)cachedResponse client:(id<NSURLProtocolClient>)client {
    NSLog(@"RC - CustomHTTPProtocol Init");
    if (self = [super initWithRequest:request cachedResponse:cachedResponse client:client]) {
        self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    }
    
    return self;
}

#pragma mark - 配置类方法

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    if (![self shouldHandleRequest:request]) {
        return NO;
    }
    
    //避免同接口任务重复处理
    if ([self propertyForKey:@"URLProtocolRequestHandled" inRequest:request] != nil) {
        return NO;
    }
    
    return YES;
}

/// 过滤需要屏蔽统计的域名请求
+ (BOOL)shouldHandleRequest:(NSURLRequest *)request {
    if (request.URL.host.length == 0) {
        return NO;
    }
    
    BOOL ignoredHost = NO;
    for (NSString *url in self.ignoredHosts) {
        if ([request.URL.host isEqual:url]) {
            ignoredHost = YES;
            break;
        }
    }
    
    return !ignoredHost;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

#pragma mark - 任务开始结束

- (void)startLoading {
    NSLog(@"RC - CustomHTTPProtocol StartLoading");
    NSMutableURLRequest *newRequest = (NSMutableURLRequest *)((NSURLRequest *)self.request).mutableCopy;
    [RCCustomHTTPProtocol setProperty:@(YES) forKey:@"URLProtocolRequestHandled" inRequest:newRequest];
    self.sessionTask = [self.session dataTaskWithRequest:newRequest];
    [self.sessionTask resume];
    
    self.currentRequest = [[RCRequestModel alloc] initWithRequest:newRequest session:self.session];
    //[[RCRequestStorage sharedInstance] saveRequest:self.currentRequest];
}

- (void)stopLoading {
    NSLog(@"RC - CustomHTTPProtocol StopLoading");
    [self.sessionTask cancel];
    self.currentRequest.httpBody = [self bodyFromRequest:self.request];
    
    //配置请求响应时长
    NSDate *startDate = self.currentRequest.date;
    if (startDate != nil) {
        self.currentRequest.duration = fabs(startDate.timeIntervalSinceNow) * 1000;
    }
    
    [[RCRequestStorage sharedInstance] saveRequest:self.currentRequest];
    [self.session invalidateAndCancel];
}

/// 处理 body 相关数据
- (NSData *)bodyFromRequest:(NSURLRequest *)request {
    if (request.HTTPBody) {
        return request.HTTPBody;
    }
    
    return [request.HTTPBodyStream readfully];
}

#pragma mark - URLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    [self.client URLProtocol:self didLoadData:data];
    if (self.currentRequest.dataResponse == nil) {
        self.currentRequest.dataResponse = [NSMutableData dataWithData:data];
    } else {
        [self.currentRequest.dataResponse appendData:data];
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    NSURLCacheStoragePolicy policy = (NSURLCacheStoragePolicy)self.request.cachePolicy;
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:policy];
    [self.currentRequest setupResponse:response];
    if (completionHandler) {
        completionHandler(NSURLSessionResponseAllow);
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (error) {
        self.currentRequest.errorClientDescription = error.localizedDescription;
        [self.client URLProtocol:self didFailWithError:error];
    } else {
        [self.client URLProtocolDidFinishLoading:self];
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler {
    [self.client URLProtocol:self wasRedirectedToRequest:request redirectResponse:response];
    if (completionHandler) {
        completionHandler(request);
    }
}

- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error {
    if (error == nil) {
        return;
    }
    
    self.currentRequest.errorClientDescription = error.localizedDescription;
    [self.client URLProtocol:self didFailWithError:error];
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    NSURLProtectionSpace *protectionSpace = challenge.protectionSpace;
    id sender = challenge.sender;
    
    if (protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
        if (protectionSpace.serverTrust) {
            NSURLCredential *credential = [[NSURLCredential alloc] initWithTrust:protectionSpace.serverTrust];
            [sender useCredential:credential forAuthenticationChallenge:challenge];
            if (completionHandler) {
                completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
            }
        }
    }
}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
    [self.client URLProtocolDidFinishLoading:self];
}

#pragma mark - 存读方法

+ (void)setIgnoredHosts:(NSArray<NSString *> *)ignoredHosts {
    _ignoredHosts = ignoredHosts;
}

+ (NSArray<NSString *> *)ignoredHosts {
    return _ignoredHosts;
}

#pragma mark - Dealloc

- (void)dealloc {
    self.session = nil;
    self.sessionTask = nil;
    self.currentRequest = nil;
}

@end
