//
//  RCRequestCell.m
//  Keep
//
//  Created by weidianwen on 2022/1/6.
//  Copyright © 2022 Beijing Calorie Technology Co., Ltd. All rights reserved.
//

#import "RCRequestCell.h"
#import "RCColors.h"
#import "NSString+RC.h"
#import <Masonry/Masonry.h>

@implementation RCRequestCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    [self.contentView addSubview:self.methodLabel];
    [self.contentView addSubview:self.codeLabel];
    [self.contentView addSubview:self.durationLabel];
    [self.contentView addSubview:self.urlLabel];

    [self.methodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(5);
        make.height.mas_equalTo(25);
    }];
    
    [self.codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.equalTo(self.contentView);
        make.height.mas_equalTo(16);
        make.width.mas_equalTo(35);
    }];
    
    [self.durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(-5);
        make.height.mas_equalTo(25);
    }];
    
    [self.urlLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15 + 50 + 20);
        make.centerY.equalTo(self.contentView);
        make.right.mas_equalTo(-15);
    }];
}

- (void)populate:(RCRequestModel *)request {
    if (request == nil) {
        return;
    }
    
    self.methodLabel.text = request.method.uppercaseString;
    self.codeLabel.hidden = request.code == 0 ? YES : NO;
    self.codeLabel.text = request.code != 0 ? [NSString stringWithFormat:@"%zd", request.code] : @"-";
    
    //NSLog(@"self.codeLabel.text = %@", self.codeLabel.text);
    
    UIColor *color = [RCColors HTTPCodeGeneric];
    if (request.code >= 200 && request.code < 300) {
        color = RCColors.HTTPCodeSuccess;
    } else if (request.code >= 300 && request.code < 400) {
        color = RCColors.HTTPCodeRedirect;
    } else if (request.code >= 400 && request.code < 500) {
        color = RCColors.HTTPCodeClientError;
    } else if (request.code >= 500 && request.code < 600) {
        color = RCColors.HTTPCodeServerError;
    }
    
    self.codeLabel.layer.borderColor = color.CGColor;
    self.codeLabel.textColor = color;
    
    self.urlLabel.text = request.url;
    self.durationLabel.text = [NSString formattedMilliseconds:request.duration];
}

- (UILabel *)methodLabel {
    if (!_methodLabel) {
        _methodLabel = [[UILabel alloc] init];
        _methodLabel.textColor = [RCColors colorWithHexString:@"#333333"];
        _methodLabel.font = [UIFont boldSystemFontOfSize:15];
    }
    return _methodLabel;
}

- (UILabel *)codeLabel {
    if (!_codeLabel) {
        _codeLabel = [[UILabel alloc] init];
        _codeLabel.font = [UIFont systemFontOfSize:13];
        _codeLabel.textAlignment = NSTextAlignmentCenter;
        _codeLabel.layer.masksToBounds = YES;
        _codeLabel.layer.cornerRadius = 5;
        _codeLabel.layer.borderWidth = 0.5;
    }
    return _codeLabel;
}

- (UILabel *)durationLabel {
    if (!_durationLabel) {
        _durationLabel = [[UILabel alloc] init];
        _durationLabel.font = [UIFont systemFontOfSize:15];
        _durationLabel.textColor = [RCColors colorWithHexString:@"#333333"];
    }
    return _durationLabel;
}

- (UILabel *)urlLabel {
    if (!_urlLabel) {
        _urlLabel = [[UILabel alloc] init];
        _urlLabel.font = [UIFont systemFontOfSize:15];
        _urlLabel.textColor = [RCColors colorWithHexString:@"#333333"];
        _urlLabel.numberOfLines = 3;
    }
    return _urlLabel;
}

@end
