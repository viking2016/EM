//
//  ESSMessageController.m
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2017/9/18.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "ESSMessageController.h"

#import "ESSMessageListController.h"

@interface ESSMessageController ()

@property (nonatomic ,strong) NSMutableArray <NSString *>*aTitles;

@end

@implementation ESSMessageController

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

#pragma -mark WMPageControllerDataSource
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.aTitles.count;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.aTitles[index];
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    ESSMessageListController *vc = [[ESSMessageListController alloc] init];
    vc.msgtype = _aTitles[index];
    return vc;
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"消息中心";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self downloadData];
}

- (void)downloadData {
    if (self.aTitles.count == 0) {
        [SVProgressHUD show];
        self.aTitles = [[NSMutableArray alloc] init];
        [ESSNetworkingTool GET:@"/APP/Elev_Push/getMsgType" parameters:nil success:^(NSDictionary * _Nonnull responseObject) {
            [SVProgressHUD dismiss];
            if ([responseObject[@"datas"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dic in responseObject[@"datas"]) {
                    NSString *name = [dic objectForKey:@"Name"];
                    [self.aTitles addObject:name];
                }
                [self reloadData];
            }
        }];
    }
}

@end
