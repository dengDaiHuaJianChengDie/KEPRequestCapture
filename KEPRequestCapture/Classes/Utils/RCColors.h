//
//  RCColors.h
//  KEPRequestCapture
//
//  Created by weidianwen on 2022/1/6.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCColors : NSObject

@property (nonatomic, strong, class, readonly) UIColor *uiWordsInEvidence;
@property (nonatomic, strong, class, readonly) UIColor *uiWordFocus;

@property (nonatomic, strong, class, readonly) UIColor *drayDarkestGray;
@property (nonatomic, strong, class, readonly) UIColor *drayDarkerGray;
@property (nonatomic, strong, class, readonly) UIColor *drayDarkGray;
@property (nonatomic, strong, class, readonly) UIColor *drayMidGray;
@property (nonatomic, strong, class, readonly) UIColor *drayLightGray;
@property (nonatomic, strong, class, readonly) UIColor *drayLighestGray;

@property (nonatomic, strong, class, readonly) UIColor *HTTPCodeSuccess;
@property (nonatomic, strong, class, readonly) UIColor *HTTPCodeRedirect;
@property (nonatomic, strong, class, readonly) UIColor *HTTPCodeClientError;
@property (nonatomic, strong, class, readonly) UIColor *HTTPCodeServerError;
@property (nonatomic, strong, class, readonly) UIColor *HTTPCodeGeneric;

+ (UIColor *)colorWithHexString:(NSString *)hexString;

@end

NS_ASSUME_NONNULL_END
