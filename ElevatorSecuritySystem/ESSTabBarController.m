//
//  ESSTabBarController.m
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2017/4/7.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "ESSTabBarController.h"
#import "ESSTabBar.h"
#import "ESSScanViewController.h"

static NSString *const kHomeItem = @"ESSHomeController/主页/icon_tab_zhuye/icon_tab_zhuye_pre";
static NSString *const kNewsItem = @"ZXNewsController/资讯/icon_tab_zixun/icon_tab_zixun_pre";
static NSString *const kTaskItem = @"ESSMessageController/消息/icon_tab_xiaoxi/icon_tab_xiaoxi_pre";
static NSString *const kInformationItem = @"ESSMeController/我的/icon_tab_wode/icon_tab_wode_pre";

@interface ESSTabBarController ()

@property (strong, nonatomic) NSArray *localDataArr;

@end

@implementation ESSTabBarController

- (NSArray *)localDataArr {
    if (!_localDataArr) {
        _localDataArr = @[kHomeItem, kNewsItem, kTaskItem, kInformationItem];
    }
    return _localDataArr;
}

#pragma mark - Private Method
- (void)p_setTabberItemWithController:(NSString *)controller title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectImage {
    UIViewController *vc = [[NSClassFromString(controller) alloc] init];
    ESSNavigationController *nav = [[ESSNavigationController alloc] initWithRootViewController:vc];
    nav.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:image] selectedImage:[UIImage imageNamed:selectImage]];
    [self addChildViewController:nav];
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSFontAttributeName] = attrs[NSFontAttributeName];
    selectedAttrs[NSForegroundColorAttributeName] = MAINCOLOR;
    
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
    for (NSString *str in self.localDataArr) {
        NSArray *itemInfos = [str componentsSeparatedByString:@"/"];
        [self p_setTabberItemWithController:itemInfos[0] title:itemInfos[1] image:itemInfos[2] selectedImage:itemInfos[3]];
    }
    
    ESSScanViewController *scan = [[ESSScanViewController alloc] init];
    
    __weak typeof(self) weakSelf = self;
    
    ESSTabBar *tabbar = [[ESSTabBar alloc] initWithBlock:^(UIButton *scanBtn) {
        [weakSelf.selectedViewController pushViewController:scan animated:YES];
    }];
    [self setValue:tabbar forKeyPath:@"tabBar"];
}

@end
