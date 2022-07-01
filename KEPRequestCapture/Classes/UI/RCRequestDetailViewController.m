//
//  RCRequestDetailViewController.m
//  Keep
//
//  Created by weidianwen on 2022/1/7.
//  Copyright © 2022 Beijing Calorie Technology Co., Ltd. All rights reserved.
//

#import "RCRequestDetailViewController.h"
#import "RCSection.h"
#import "RCRequestModelBeautifier.h"
#import "RCRequestTitleSectionView.h"
#import "RCTextTableViewCell.h"
#import "RCActionableTableViewCell.h"
#import "RCBodyDetailViewController.h"
#import "RCRequestStorage.h"
#import <Masonry/Masonry.h>
#import "RCShareUtils.h"
#import "RCColors.h"

@interface RCRequestDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray<RCSection *> *sections;
@property (nonatomic, strong) UIColor *labelTextColor;

@end

@implementation RCRequestDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    RCSection *setion1 = [[RCSection alloc] initWithName:@"Overview" type:RCSectionTypeOverview];
    RCSection *setion2 = [[RCSection alloc] initWithName:@"Request Header" type:RCSectionTypeRequestHeader];
    RCSection *setion3 = [[RCSection alloc] initWithName:@"Request Body" type:RCSectionTypeRequestBody];
    RCSection *setion4 = [[RCSection alloc] initWithName:@"Response Header" type:RCSectionTypeResponseHeader];
    RCSection *setion5 = [[RCSection alloc] initWithName:@"Response Body" type:RCSectionTypeResponseBody];
    self.sections = @[setion1, setion2, setion3, setion4, setion5];

    self.title = @"接口详情";
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(openActionSheet:)];
    self.navigationItem.rightBarButtonItems = @[shareButton];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - Actions

- (void)openActionSheet:(UIBarButtonItem *)sender {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"请选择操作" message:@"" preferredStyle:UIAlertControllerStyleActionSheet] ;
    [ac addAction:[UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self shareContent:sender requestExportOption:RCRequestResponseExportOptionFlat];
    }]];
    [ac addAction:[UIAlertAction actionWithTitle:@"分享CURL" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self shareContent:sender requestExportOption:RCRequestResponseExportOptionCurl];
    }]];
    [ac addAction:[UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    }]];
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        ac.popoverPresentationController.barButtonItem = sender;
    }
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)shareContent:(UIBarButtonItem *)sender requestExportOption:(RCRequestResponseExportOption)requestExportOption {
    NSMutableArray *requests = [NSMutableArray arrayWithObject:self.request];
    [RCShareUtils shareRequests:self sender:sender requests:requests requestExportOption:requestExportOption];
}

- (void)openBodyDetailVC:(NSString *)title body:(NSData *)body {
    RCBodyDetailViewController *bodyDetailVC = [[RCBodyDetailViewController alloc] init];
    bodyDetailVC.title = title;
    bodyDetailVC.data = body;
    [self.navigationController pushViewController:bodyDetailVC animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    RCRequestTitleSectionView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"RCRequestTitleSectionView"];
    header.titleLabel.text = [self.sections objectAtIndex:section].name;
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.request == nil) {
        return [[UITableViewCell alloc] init];
    }
    
    RCSection *section = [self.sections objectAtIndex:indexPath.section];
    switch (section.type) {
        case RCSectionTypeOverview:
        {
            RCTextTableViewCell *cell = (RCTextTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"RCTextTableViewCell" forIndexPath:indexPath];
            cell.textView.attributedText = [[RCRequestModelBeautifier overview:self.request] rc_chageTextColor:self.labelTextColor];
            return cell;
        }
        case RCSectionTypeRequestHeader:
        {
            RCTextTableViewCell *cell = (RCTextTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"RCTextTableViewCell" forIndexPath:indexPath];
            cell.textView.attributedText = [[RCRequestModelBeautifier header:self.request.headers] rc_chageTextColor:self.labelTextColor];
            return cell;
        }
        case RCSectionTypeRequestBody:
        {
            RCActionableTableViewCell *cell = (RCActionableTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"RCActionableTableViewCell" forIndexPath:indexPath];
            cell.actionLabel.text = @"View Body";
            return cell;
        }
        case RCSectionTypeResponseHeader:
        {
            RCTextTableViewCell *cell = (RCTextTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"RCTextTableViewCell" forIndexPath:indexPath];
            cell.textView.attributedText = [[RCRequestModelBeautifier header:self.request.responseHeaders] rc_chageTextColor:self.labelTextColor];
            return cell;
        }
        case RCSectionTypeResponseBody:
        {
            RCActionableTableViewCell *cell = (RCActionableTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"RCActionableTableViewCell" forIndexPath:indexPath];
            cell.actionLabel.text = @"View Body";
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RCSection *section = [self.sections objectAtIndex:indexPath.section];
    switch (section.type) {
        case RCSectionTypeRequestBody:
            [self openBodyDetailVC:@"Request Body" body:self.request.httpBody];
            break;
        case RCSectionTypeResponseBody:
            [self openBodyDetailVC:@"Response Body" body:self.request.dataResponse];
            break;
        default:
            break;
    }
}

#pragma mark - lazyload

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerClass:RCTextTableViewCell.class forCellReuseIdentifier:@"RCTextTableViewCell"];
        [_tableView registerClass:RCActionableTableViewCell.class forCellReuseIdentifier:@"RCActionableTableViewCell"];
        [_tableView registerClass:RCRequestTitleSectionView.class forHeaderFooterViewReuseIdentifier:@"RCRequestTitleSectionView"];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 100.0;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [RCColors rc_colorWithHexString:@"#E8E8E8"];
    }
    return _tableView;
}

- (UIColor *)labelTextColor {
    if (@available(iOS 13.0, *)) {
        return [UIColor labelColor];
    } else {
        return [UIColor blackColor];
    }
}

@end
