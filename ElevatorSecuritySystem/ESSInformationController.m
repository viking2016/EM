//
//  ESSInformationController.m
//  ElevatorMaintenanceAssistant
//
//  Created by 刘树龙 on 17/2/24.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co., Ltd. All rights reserved.
//

#import "ESSInformationController.h"

#import "ESSInformationListController.h"

@interface ESSInformationController ()

@property (nonatomic ,strong) NSMutableArray <NSString *>*aTitles;

@end

@implementation ESSInformationController

#pragma mark - Public Method 

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.menuHeight = 50;
        self.menuBGColor = [UIColor whiteColor];
        self.menuItemWidth = 80;
        self.titleColorNormal = [UIColor blackColor];
        self.titleColorSelected = MAINCOLOR;
        self.menuViewStyle = WMMenuViewStyleLine;
        self.pageAnimatable = YES;
        self.progressColor = MAINCOLOR;
        self.titleSizeNormal = 14;
        self.titleSizeSelected = 14;
    }
    return self;
}

#pragma mark - Private Method

- (void)downloadData {
    if (self.aTitles.count == 0) {
        [SVProgressHUD show];
        self.aTitles = [[NSMutableArray alloc] init];
        [ESSNetworkingTool GET:@"APP/CMS/CMS_News/GetLanMu" parameters:nil success:^(NSDictionary * _Nonnull responseObject) {
            [SVProgressHUD dismiss];
            if ([responseObject isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dic in responseObject) {
                    NSString *name = [dic objectForKey:@"Name"];
                    [self.aTitles addObject:name];
                }
                [self reloadData];
            }
        }];
    }
}

#pragma -mark WMPageControllerDataSource
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.aTitles.count;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.aTitles[index];
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    ESSInformationListController *vc = [[ESSInformationListController alloc] init];
    vc.type = self.aTitles[index];
    return vc;
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"资讯"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self downloadData];
}
@end

