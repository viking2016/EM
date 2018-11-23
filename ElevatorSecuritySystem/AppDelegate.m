//
//  AppDelegate.m
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2017/4/6.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//     LSLEaseTestDevelopment  

#import "AppDelegate.h"
#import <JPUSHService.h>
#import "IQKeyboardManager.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>

#import "ESSRescueMessageDetailController.h"

#import "ESSTabBarController.h"

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

static NSTimeInterval delay = 2;
static NSString *const kJPushKey = @"a73c090088fcc75c85b65204";
static NSString *const kJPushChannel = @"App Store";
static const BOOL kJPushIsProduction = TRUE;
static NSString *const baiduKey = @"AaUrSrA4n5jxkxFymKOc5MrGAoBp81Kv";

@interface AppDelegate ()<JPUSHRegisterDelegate>

@property (strong, nonatomic) BMKMapManager *manager;

@end

@implementation AppDelegate

#pragma mark - Private Method
- (void)registerIQKeyboardManager {
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = YES;
}


- (void)setupSVProgressHUD {
    [SVProgressHUD setMinimumDismissTimeInterval:2];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithWhite:0.3333 alpha:0.5]];
}

- (void)presentTotTargetControllerWithUserInfo:(NSDictionary *)userInfo {

    ESSRescueMessageDetailController *vc = [[ESSRescueMessageDetailController alloc]initWithUserInfo:userInfo];
    UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.window.rootViewController presentViewController:na animated:YES completion:nil];
    
}

- (void)showAlertWithUserInfo:(NSDictionary *)userInfo {
    NSString *message = userInfo[@"Title"];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *check = [UIAlertAction actionWithTitle:@"查看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self presentTotTargetControllerWithUserInfo:userInfo];
    }];
    [alert addAction:cancel];
    [alert addAction:check];
    [self.window.rootViewController.presentedViewController presentViewController:alert animated:YES completion:^{
    }];
}


#pragma mark Life Cycle
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    sleep(delay);
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [ESSTabBarController new];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    // registerJPush
    JPUSHRegisterEntity *entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    [JPUSHService setupWithOption:launchOptions appKey:kJPushKey channel:kJPushChannel apsForProduction:kJPushIsProduction];
    
    [self registerIQKeyboardManager];
    [self setupSVProgressHUD];
    
    // registerBMK
    self.manager = [[BMKMapManager alloc] init];
    [_manager start:baiduKey generalDelegate:nil];
    
    [ESSLoginTool autoLogin];
    
    // 是否是点击推送启动App
    NSDictionary *remoteNotification = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotification) {// 有推送消息需要处理
        [[NSUserDefaults standardUserDefaults] setObject:remoteNotification forKey:@"remoteInfo"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
}


// APP进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [application setApplicationIconBadgeNumber:0];
}


// APP将要从后台返回
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [application setApplicationIconBadgeNumber:0];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)messagesDidReceive:(NSArray *)aMessages{
    
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    if ([userInfo[@"InfoType"] isEqualToString:@"通知刷新"]||[userInfo[@"InfoType"] isEqualToString:@"新闻刷新"]||[userInfo[@"InfoType"] isEqualToString:@"救援消息"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getHomeData" object:nil];
    }
    
    if ([[UIDevice currentDevice].systemVersion floatValue] < 10.0) {
        if (application.applicationState > 0) {
            [self presentTotTargetControllerWithUserInfo:userInfo];
        }else {
            [self showAlertWithUserInfo:userInfo];
        }
    }
    completionHandler(UIBackgroundFetchResultNewData);
}

// 注册deviceToken失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
   NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}


#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    if ([userInfo[@"InfoType"] isEqualToString:@"通知刷新"]||[userInfo[@"InfoType"] isEqualToString:@"新闻刷新"]||[userInfo[@"InfoType"] isEqualToString:@"救援消息"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getHomeData" object:nil];
//        [JPUSHService handleRemoteNotification:userInfo];
        completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
    }else {
        if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [JPUSHService handleRemoteNotification:userInfo];
        }else {
            
        }
        completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
    }
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    
    if ([userInfo[@"InfoType"] isEqualToString:@"通知刷新"]||[userInfo[@"InfoType"] isEqualToString:@"新闻刷新"]||[userInfo[@"InfoType"] isEqualToString:@"救援消息"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getHomeData" object:nil];
    }
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        [self presentTotTargetControllerWithUserInfo:userInfo];
    }
    else {
        
    }
    completionHandler();  // 系统要求执行这个方法
}
#endif

@end
