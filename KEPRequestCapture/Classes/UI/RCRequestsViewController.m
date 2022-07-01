//
//  RCRequestsViewController.m
//  Keep
//
//  Created by weidianwen on 2022/1/6.
//  Copyright © 2022 Beijing Calorie Technology Co., Ltd. All rights reserved.
//

#import "RCRequestsViewController.h"
#import "RCRequestModel.h"
#import "RCRequestCell.h"
#import "RCRequestStorage.h"
#import "RCColors.h"
#import "RCRequestModelBeautifier.h"
#import <Masonry/Masonry.h>
#import "RCRequestDetailViewController.h"
//#import "RCShareUtils.h"

@interface RCRequestsViewController () <UISearchResultsUpdating, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

/// 展示数据源
@property (nonatomic, strong) NSMutableArray<RCRequestModel *> *filteredRequests;
/// 搜索控制器
@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation RCRequestsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"接口列表";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"More" style:UIBarButtonItemStylePlain target:self action:@selector(openActionSheet:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction)];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self addSearchController];
    [self loadOrginData];
    
}

- (void)addSearchController {
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    
    if (@available(iOS 9.1, *)) {
        self.searchController.obscuresBackgroundDuringPresentation = NO;
    }
    
    self.searchController.searchBar.placeholder = @"Search URL";
    
    if (@available(iOS 11.0, *)) {
        self.navigationItem.searchController = self.searchController;
    } else {
        self.navigationItem.titleView = self.searchController.searchBar;
    }
    
    self.definesPresentationContext = YES;
    self.searchController.active = YES;
}

- (void)loadOrginData {
    self.filteredRequests = [[[RCRequestStorage sharedInstance] loadAllReuestsCache] mutableCopy];
    [self.collectionView reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"wormholy_new_request" object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.filteredRequests = [self filterRequestsWithKeyword:self.searchController.searchBar.text];
            [self.collectionView reloadData];
        });
    }];
}

- (NSMutableArray<RCRequestModel *> *)filterRequestsWithKeyword:(NSString *)text {
    if (text.length == 0) {
        return [[[RCRequestStorage sharedInstance] loadAllReuestsCache] mutableCopy];
    }
    
    NSMutableArray *result = [NSMutableArray array];
    for (RCRequestModel *model in [[RCRequestStorage sharedInstance] loadAllReuestsCache]) {
        NSRange range = [model.url rangeOfString:text options:NSCaseInsensitiveSearch];
        if (range.length != 0) {
            [result addObject:model];
        }
    }
    
    return result;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
        flowLayout.itemSize = CGSizeMake(UIScreen.mainScreen.bounds.size.width, 76);
        [self.collectionView reloadData];
    }];
}

#pragma mark - Actions

- (void)openActionSheet:(UIBarButtonItem *)sender {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"请选择操作" message:@"" preferredStyle:UIAlertControllerStyleActionSheet] ;
    [ac addAction:[UIAlertAction actionWithTitle:@"清空" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self clearRequests];
    }]];
    /* 列表页没必要分享
    [ac addAction:[UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self shareContent:sender requestExportOption:RCRequestResponseExportOptionFlat];
    }]];
    [ac addAction:[UIAlertAction actionWithTitle:@"分享CURL" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self shareContent:sender requestExportOption:RCRequestResponseExportOptionCurl];
    }]]; */
    [ac addAction:[UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    }]];
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        ac.popoverPresentationController.barButtonItem = sender;
    }
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)doneAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clearRequests {
    [[RCRequestStorage sharedInstance] clearAllRequestCache];
    self.filteredRequests = [NSMutableArray array];
    [self.collectionView reloadData];
}

- (void)shareContent:(UIBarButtonItem *)sender requestExportOption:(RCRequestResponseExportOption)requestExportOption {
    //列表页没必要分享
    //[RCShareUtils shareRequests:self sender:sender requests:self.filteredRequests requestExportOption:requestExportOption];
}

- (void)openRequestDetailVC:(RCRequestModel *)request {
    RCRequestDetailViewController *detailVC = [[RCRequestDetailViewController alloc] init];
    detailVC.request = request;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.filteredRequests.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RCRequestCell *cell = (RCRequestCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"RCRequestCell" forIndexPath:indexPath];
    [cell populate:[self.filteredRequests objectAtIndex:indexPath.item]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self openRequestDetailVC:[self.filteredRequests objectAtIndex:indexPath.item]];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.collectionView.bounds.size.width, 76);
}

#pragma mark - UISearchResultsUpdating Delegate

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    self.filteredRequests = [self filterRequestsWithKeyword:self.searchController.searchBar.text];
    [self.collectionView reloadData];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        //layout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 76);
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [RCColors rc_colorWithHexString:@"#FAFAFA"];
        [_collectionView registerClass:[RCRequestCell class] forCellWithReuseIdentifier:NSStringFromClass([RCRequestCell class])];
    }
    return _collectionView;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
