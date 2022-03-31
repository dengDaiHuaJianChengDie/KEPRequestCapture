//
//  RCFileHandler.m
//  Keep
//
//  Created by weidianwen on 2022/1/7.
//  Copyright © 2022 Beijing Calorie Technology Co., Ltd. All rights reserved.
//

#import "RCFileHandler.h"

@implementation RCFileHandler

+ (void)writeTxtFile:(NSString *)text path:(NSString *)path {
    [[NSFileManager defaultManager] createFileAtPath:path contents:[text dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
}

+ (void)writeTxtFileOnDesktop:(NSString *)text fileName:(NSString *)fileName {
    NSArray *components = [[@"~" stringByExpandingTildeInPath] componentsSeparatedByString:@"/"];
    NSString *homeUser = @"-";
    if (components.count > 2) {
        homeUser = [components objectAtIndex:2];
    }

    NSString *path = [NSString stringWithFormat:@"Users/%@/Desktop/%@", homeUser, fileName];
    [self writeTxtFile:text path:path];
}

@end
