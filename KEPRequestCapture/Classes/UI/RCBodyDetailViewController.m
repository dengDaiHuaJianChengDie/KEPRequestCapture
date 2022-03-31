//
//  RCBodyDetailViewController.m
//  Keep
//
//  Created by weidianwen on 2022/1/7.
//  Copyright © 2022 Beijing Calorie Technology Co., Ltd. All rights reserved.
//

#import "RCBodyDetailViewController.h"
#import <Masonry/Masonry.h>
#import "RCRequestModelBeautifier.h"
#import "RCColors.h"

@interface RCBodyDetailViewController () <UISearchResultsUpdating, UISearchBarDelegate>

@end

@implementation RCBodyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupSubView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareContent:)];
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(showSearch)];
    self.navigationItem.rightBarButtonItems = @[searchButton, shareButton];
    
    [self addSearchController];
}

/*
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self addSearchController];
} */

- (void)setupSubView {
    [self.view addSubview:self.toolBar];
    [self.toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.mas_equalTo(50 + 20);
    }];
    
    [self.toolBar addSubview:self.labelWordFinded];
    [self.labelWordFinded mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.toolBar);
        make.centerX.equalTo(self.toolBar);
        make.height.mas_equalTo(50);
    }];
    
    [self.toolBar addSubview:self.buttonNext];
    [self.buttonNext mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.toolBar);
        make.width.height.mas_equalTo(50);
        make.left.equalTo(self.labelWordFinded.mas_right).offset(30);
    }];
    
    [self.toolBar addSubview:self.buttonPrevious];
    [self.buttonPrevious mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.toolBar);
        make.width.height.mas_equalTo(50);
        make.right.equalTo(self.labelWordFinded.mas_left).offset(-30);
    }];
    
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-70);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIView *hud = [self showLoader:self.view];
    [RCRequestModelBeautifier body:self.data splitLength:0 completion:^(NSString * _Nonnull formattedJSON) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.textView.text = formattedJSON;
            [self hideLoader:hud];
        });
    }];
}

- (void)addSearchController {
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.returnKeyType = UIReturnKeyDone;
    self.searchController.searchBar.delegate = self;
    
    if (@available(iOS 9.1, *)) {
        self.searchController.obscuresBackgroundDuringPresentation = NO;
    } else {
        // Fallback
    }
    
    self.searchController.searchBar.placeholder = @"Search";
    if (@available(iOS 11.0, *)) {
        self.navigationItem.searchController = self.searchController;
    } else {
        self.navigationItem.titleView = self.searchController.searchBar;
    }
    
    self.definesPresentationContext = YES;
}

#pragma mark - Keyboard

- (void)handleKeyboardWillShow:(NSNotification *)sender {
    CGSize keyboardSize = [[sender.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    [self animationInputViewWithHeight:-keyboardSize.height notification:sender];
}

- (void)handleKeyboardWillHide:(NSNotification *)sender {
    [self animationInputViewWithHeight:0.0 notification:sender];
}

- (void)animationInputViewWithHeight:(CGFloat)height notification:(NSNotification *)notification {
    NSTimeInterval duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    NSInteger curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    //这里可以通过约束将 toolBar 升到键盘上面
    
    [UIView animateWithDuration:duration delay:0.0 options:curve animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];
}

#pragma mark - Action

- (void)shareContent:(UIBarButtonItem *)sender {
    if (self.textView.text.length > 0) {
        NSArray *textShare = @[self.textView.text];
        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:textShare applicationActivities:nil];
        activityViewController.popoverPresentationController.barButtonItem = sender;
        [self presentViewController:activityViewController animated:YES completion:nil];
    }
}

- (void)showSearch {
    self.searchController.active = YES;
}

- (void)previousStep {
    self.indexOfWord -= 1;
    if (self.indexOfWord < 0) {
        self.indexOfWord = self.highlightedWords.count - 1;
    }
    
    [self getCursor];
}

- (void)nextStep {
    self.indexOfWord += 1;
    if (self.indexOfWord >= self.highlightedWords.count) {
        self.indexOfWord = 0;
    }
    
    [self getCursor];
}

- (void)getCursor {
    NSTextCheckingResult *value = [self.highlightedWords objectAtIndex:self.indexOfWord];
    UITextRange *range = [self.textView convertRange:value.range];
    if (range) {
        CGRect rect = [self.textView firstRectForRange:range];
        self.labelWordFinded.text = [NSString stringWithFormat:@"%zd of %lu", (long)(self.indexOfWord + 1), (unsigned long)self.highlightedWords.count];
        CGRect focusRect = {self.textView.contentOffset, self.textView.frame.size};
        if (CGRectContainsRect(focusRect, rect)) {
            [self.textView setContentOffset:CGPointMake(0, rect.origin.y - rcPadding) animated:YES];
        }
        
        [self cursorAnimation:value.range];
    }
}

- (void)cursorAnimation:(NSRange)range {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.textView.attributedText];
    for (NSTextCheckingResult *value in self.highlightedWords) {
        [attributedString addAttributes:@{NSBackgroundColorAttributeName: RCColors.uiWordsInEvidence} range:value.range];
        [attributedString addAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Courier-Bold" size:14]} range:value.range];
    }
    
    self.textView.attributedText = attributedString;
    
    [attributedString addAttributes:@{NSBackgroundColorAttributeName: RCColors.uiWordFocus} range:range];
    self.textView.attributedText = attributedString;
}

- (void)resetSearchText {
    [self resetTextAttribute];
    
    self.labelWordFinded.text = @"0 of 0";
    self.buttonPrevious.enabled = NO;
    self.buttonNext.enabled = NO;
}

- (void)resetTextAttribute {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.textView.attributedText];
    [attributedString addAttributes:@{NSBackgroundColorAttributeName: UIColor.clearColor} range:NSMakeRange(0, self.textView.attributedText.length)];
    [attributedString addAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Courier" size:14]} range:NSMakeRange(0, self.textView.attributedText.length)];
    
    self.textView.attributedText = attributedString;
}

- (void)performSearch:(NSString *)text {
    [self.highlightedWords removeAllObjects];
    [self resetTextAttribute];
    
    self.highlightedWords = [self.textView highlights:text color:RCColors.uiWordsInEvidence font:[UIFont fontWithName:@"Courier" size:14] highlightedFont:[UIFont fontWithName:@"Courier-Bold" size:14]];
    
    self.indexOfWord = 0;
    if (self.highlightedWords.count != 0) {
        [self getCursor];
        self.buttonPrevious.enabled = YES;
        self.buttonNext.enabled = YES;
    } else {
        self.buttonPrevious.enabled = NO;
        self.buttonNext.enabled = NO;
        self.labelWordFinded.text = @"0 of 0";
    }
}

#pragma mark - UISearchBarDelegate

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    if (searchController.searchBar.text.length > 0) {
        [self performSearch:searchController.searchBar.text];
    } else {
        [self resetSearchText];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

#pragma mark - Lazyload

- (RCTextView *)textView {
    if (!_textView) {
        _textView = [[RCTextView alloc] init];
        _textView.font = [UIFont fontWithName:@"Courier" size:14];
        _textView.dataDetectorTypes = UIDataDetectorTypeLink;
        _textView.showsVerticalScrollIndicator = NO;
        _textView.showsHorizontalScrollIndicator = NO;
        _textView.editable = NO;
    }
    return _textView;
}

- (UIView *)toolBar {
    if (!_toolBar) {
        _toolBar = [[UIView alloc] init];
        _toolBar.backgroundColor = [RCColors colorWithHexString:@"#E8E8E8"];
    }
    return _toolBar;
}

- (UIButton *)buttonNext {
    if (!_buttonNext) {
        _buttonNext = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buttonNext setTitle:@">" forState:UIControlStateNormal];
        [_buttonNext setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [_buttonNext addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
        _buttonNext.enabled = NO;
    }
    return _buttonNext;
}

- (UIButton *)buttonPrevious {
    if (!_buttonPrevious) {
        _buttonPrevious = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buttonPrevious setTitle:@"<" forState:UIControlStateNormal];
        [_buttonPrevious setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [_buttonPrevious addTarget:self action:@selector(previousStep) forControlEvents:UIControlEventTouchUpInside];
        _buttonPrevious.enabled = NO;
    }
    return _buttonPrevious;
}

- (UILabel *)labelWordFinded {
    if (!_labelWordFinded) {
        _labelWordFinded = [[UILabel alloc] init];
        _labelWordFinded.text = @"0 of 0";
        _labelWordFinded.textColor = [RCColors colorWithHexString:@"#333333"];
        _labelWordFinded.textAlignment = NSTextAlignmentCenter;
    }
    return _labelWordFinded;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
