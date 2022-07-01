//
//  NSMutableAttributedString+RC.m
//  Keep
//
//  Created by weidianwen on 2022/1/7.
//  Copyright © 2022 Beijing Calorie Technology Co., Ltd. All rights reserved.
//

#import "NSMutableAttributedString+RC.h"

@implementation NSMutableAttributedString (RC)

- (NSMutableAttributedString *)rc_bold:(NSString *)text {
    NSDictionary *attrs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:15]};
    NSMutableAttributedString *boldString = [[NSMutableAttributedString alloc] initWithString:text attributes:attrs];
    [self appendAttributedString:boldString];
    return self;
}

- (NSMutableAttributedString *)rc_normal:(NSString *)text {
    NSDictionary *attrs = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    NSMutableAttributedString *normal = [[NSMutableAttributedString alloc] initWithString:text attributes:attrs];
    [self appendAttributedString:normal];
    return self;
}

- (NSMutableAttributedString *)rc_chageTextColor:(UIColor *)toColor {
    NSRange range = NSMakeRange(0, self.string.length);
    [self addAttributes:@{NSForegroundColorAttributeName: toColor} range:range];
    return self;
}

@end
