//
//  ZXInformationController.m
//  ElevatorUnit
//
//  Created by 刘树龙 on 2018/8/10.
//  Copyright © 2018年 刘树龙. All rights reserved.
//

#import "ZXInformationController.h"
#import "ZXInformationListController.h"

@interface ZXInformationController ()

@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation ZXInformationController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.automaticallyCalculatesItemWidths = NO;
        self.titleColorNormal = [UIColor colorWithHexString:@"333333"];
        self.titleSizeSelected = 15;
        self.titleColorSelected = MAINCOLOR;
        self.menuViewStyle = WMMenuViewStyleLine;
        self.progressWidth = 40;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"消息";
    [self downloadData];
}

- (void)downloadData {
    NSDictionary *paras = @{};
    [NetworkingTool GET:@"/APP/SYS/Sys_PushLog/GetMsgType" parameters:paras success:^(id  _Nonnull responseObject) {
        NSString *msgTypeStr = responseObject[@"MsgType"];
        self.datas = [[msgTypeStr componentsSeparatedByString:@","] mutableCopy];
        [self reloadData];
    }];
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    return CGRectMake(0, 0, self.view.width, 40);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return CGRectMake(0, 40, self.view.width, self.view.height - 40);
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.datas.count;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.datas[index];
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    ZXInformationListController *vc = [[ZXInformationListController alloc] initWithMsgType:self.datas[index]];
    return vc;
}

@end
