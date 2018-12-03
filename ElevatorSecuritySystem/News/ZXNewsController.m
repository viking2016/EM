//
//  ZXNewsController.m
//  ElevatorUnit
//
//  Created by 刘树龙 on 2018/8/10.
//  Copyright © 2018年 刘树龙. All rights reserved.
//

#import "ZXNewsController.h"
#import "ZXNewsListController.h"

@interface ZXNewsController ()

@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation ZXNewsController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.automaticallyCalculatesItemWidths = true;
        self.titleColorNormal = [UIColor colorWithHexString:@"333333"];
        self.titleColorSelected = MAINCOLOR;
        self.menuViewStyle = WMMenuViewStyleLine;
        self.progressWidth = 40;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"资讯";
    [self downloadData];
}

- (void)downloadData {
    NSDictionary *paras = @{};
    [NetworkingTool GET:@"/APP/CMS/CMS_News/GetLanMu" parameters:paras success:^(id  _Nonnull responseObject) {
        self.datas = responseObject;
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
    return self.datas[index][@"MingCheng"];
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    NSString *aID = self.datas[index][@"LanMuID"];
    ZXNewsListController *vc = [[ZXNewsListController alloc] initWithLanMuID:[aID intValue]];
    return vc;
}

@end
