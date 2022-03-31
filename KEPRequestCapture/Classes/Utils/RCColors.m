//
//  RCColors.m
//  KEPRequestCapture
//
//  Created by weidianwen on 2022/1/6.
//

#import "RCColors.h"

CGFloat rc_colorComponentFrom(NSString *string, NSUInteger start, NSUInteger length) {
    NSString *substring = [string substringWithRange:NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}

@implementation RCColors

+ (UIColor *)HTTPCodeSuccess {
    return [self colorWithHexString:@"#297E4C"]; //2xx
}

+ (UIColor *)HTTPCodeRedirect {
    return [self colorWithHexString:@"#3D4140"]; //3xx
}

+ (UIColor *)HTTPCodeClientError {
    return [self colorWithHexString:@"#D97853"]; //4xx
}

+ (UIColor *)HTTPCodeServerError {
    return [self colorWithHexString:@"#D32C58"]; //5xx
}

+ (UIColor *)HTTPCodeGeneric {
    return [self colorWithHexString:@"#999999"]; //Others
}

+ (UIColor *)uiWordsInEvidence {
    return [self colorWithHexString:@"#dadfe1"];
}

+ (UIColor *)uiWordFocus {
    return [self colorWithHexString:@"#f7ca18"];
}

+ (UIColor *)drayDarkestGray {
    return [self colorWithHexString:@"#666666"];
}

+ (UIColor *)drayDarkerGray {
    return [self colorWithHexString:@"#888888"];
}

+ (UIColor *)drayDarkGray {
    return [self colorWithHexString:@"#999999"];
}

+ (UIColor *)drayMidGray {
    return [self colorWithHexString:@"#BBBBBB"];
}

+ (UIColor *)drayLightGray {
    return [self colorWithHexString:@"#CCCCCC"];
}

+ (UIColor *)drayLighestGray {
    return [self colorWithHexString:@"#E7E7E7"];
}

+ (UIColor *)colorWithHexString:(NSString *)hexString {
    CGFloat alpha, red, blue, green;
    
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = rc_colorComponentFrom(colorString, 0, 1);
            green = rc_colorComponentFrom(colorString, 1, 1);
            blue  = rc_colorComponentFrom(colorString, 2, 1);
            break;
            
        case 4: // #ARGB
            alpha = rc_colorComponentFrom(colorString, 0, 1);
            red   = rc_colorComponentFrom(colorString, 1, 1);
            green = rc_colorComponentFrom(colorString, 2, 1);
            blue  = rc_colorComponentFrom(colorString, 3, 1);
            break;
            
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = rc_colorComponentFrom(colorString, 0, 2);
            green = rc_colorComponentFrom(colorString, 2, 2);
            blue  = rc_colorComponentFrom(colorString, 4, 2);
            break;
            
        case 8: // #AARRGGBB
            alpha = rc_colorComponentFrom(colorString, 0, 2);
            red   = rc_colorComponentFrom(colorString, 2, 2);
            green = rc_colorComponentFrom(colorString, 4, 2);
            blue  = rc_colorComponentFrom(colorString, 6, 2);
            break;
            
        default:
            return nil;
    }
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}


@end
