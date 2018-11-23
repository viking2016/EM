//
//  ESSSearchController.m
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2017/4/7.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "ESSSearchController.h"

#import "ESSSearchListController.h"

@interface ESSSearchController ()<PYSearchViewControllerDelegate>

@end

@implementation ESSSearchController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cancelButton.tintColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
}

#pragma mark - PYSearchViewControllerDelegate
- (void)searchViewController:(PYSearchViewController *)searchViewController searchTextDidChange:(UISearchBar *)searchBar searchText:(NSString *)searchText {
    NSLog(@"%@",searchText);
}

- (void)searchViewController:(PYSearchViewController *)searchViewController didSearchWithSearchBar:(UISearchBar *)searchBar searchText:(NSString *)searchText {
    [self.navigationController pushViewController:[[ESSSearchListController alloc] initWithKeywords:searchText] animated:YES];
}

- (void)didClickCancel:(PYSearchViewController *)searchViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

@end

