//
//  RCShareUtils.m
//  Keep
//
//  Created by weidianwen on 2022/1/7.
//  Copyright © 2022 Beijing Calorie Technology Co., Ltd. All rights reserved.
//

#import "RCShareUtils.h"
#import <UIKit/UIKit.h>

@implementation RCShareUtils

+ (void)shareRequests:(UIViewController *)presentingViewController
               sender:(UIBarButtonItem *)sender
             requests:(NSArray *)requests
  requestExportOption:(RCRequestResponseExportOption)requestExportOption {
    NSString *text = @"";
    switch (requestExportOption) {
        case RCRequestResponseExportOptionFlat:
            text = [self getTxtText:requests];
            break;
        case RCRequestResponseExportOptionCurl:
            text = [self getCurlText:requests];
            break;
        case RCRequestResponseExportOptionPostman:
            break;
    }
    
    if (text == nil) {
        text = @"";
    }
    
    NSArray *textShare = @[text];
    RCCustomActivity *customItem = [[RCCustomActivity alloc] initWithTitle:@"保存到桌面" image:nil performAction:^(NSArray * sharedItems) {
        NSArray<NSString *> *sharedStrings = sharedItems;
        if (sharedStrings.count == 0) {
            return;
        }
        
        NSString *appName = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleName"];
        NSDateFormatter *dateFormatterGet = [[NSDateFormatter alloc] init];
        [dateFormatterGet setDateFormat:@"yyyyMMdd_HHmmss_SSS"];
        
        NSString *suffix = @"";
        switch (requestExportOption) {
            case RCRequestResponseExportOptionFlat:
                suffix = @"-wormholy.txt";
                break;
            case RCRequestResponseExportOptionCurl:
                suffix = @"-wormholy.txt";
                break;
            case RCRequestResponseExportOptionPostman:
                suffix = @"-postman_collection.json";
                break;
        }
        
        NSString *date = [dateFormatterGet stringFromDate:[NSDate date]];
        NSString *filename = [NSString stringWithFormat:@"%@_%@%@", appName, date, suffix];
        
        for (NSString *string in sharedStrings) {
            [RCFileHandler writeTxtFileOnDesktop:string fileName:filename];
        }
    }];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:textShare applicationActivities:@[customItem]];
    activityViewController.popoverPresentationController.barButtonItem = sender;
    [presentingViewController presentViewController:activityViewController animated:YES completion:nil];
}

+ (NSString *)getTxtText:(NSArray<RCRequestModel *> *)requests {
    NSString *text = @"";
    for (RCRequestModel *request in requests) {
        text = [text stringByAppendingString:[RCRequestModelBeautifier txtExport:request]];
    }
    
    return text;
}

+ (NSString *)getCurlText:(NSArray<RCRequestModel *> *)requests {
    NSString *text = @"";
    for (RCRequestModel *request in requests) {
        text = [text stringByAppendingString:[RCRequestModelBeautifier curlExport:request]];
    }
    
    return text;
}


@end
