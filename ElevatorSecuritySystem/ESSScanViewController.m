//
//  ESSScanViewController.m
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2017/9/4.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "ESSScanViewController.h"
#import "LBXAlertAction.h"
#import "ESSLiftDetailController.h"
#import "ESSWebController.h"

@interface ESSScanViewController ()

@end

@implementation ESSScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"扫一扫"];
    
    self.cameraInvokeMsg = @"相机启动中";
    
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    style.centerUpOffset = 44;
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Inner;
    style.photoframeLineW = 3;
    style.photoframeAngleW = 18;
    style.photoframeAngleH = 18;
    style.isNeedShowRetangle = NO;
    
    style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;
    
    //qq里面的线条图片
    UIImage *imgLine = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_light_green"];
    style.animationImage = imgLine;
    self.style = style;
    
    self.isOpenInterestRect = YES;
    self.libraryType = SLT_Native;
}

#pragma mark -实现类继承该方法，作出对应处理

- (void)scanResultWithArray:(NSArray<LBXScanResult*>*)array
{
    if (!array ||  array.count < 1)
    {
        [self popAlertMsgWithScanResult:nil];
        
        return;
    }
    
    //经测试，可以ZXing同时识别2个二维码，不能同时识别二维码和条形码
    //    for (LBXScanResult *result in array) {
    //
    //        NSLog(@"scanResult:%@",result.strScanned);
    //    }
    
    LBXScanResult *scanResult = array[0];
    
    NSString*strResult = scanResult.strScanned;
    
    self.scanImage = scanResult.imgScanned;
    
    if (!strResult) {
        
        [self popAlertMsgWithScanResult:nil];
        
        return;
    }
    
    //TODO: 这里可以根据需要自行添加震动或播放声音提示相关代码
    //...
    
    [self showNextVCWithScanResult:scanResult];
}

- (void)popAlertMsgWithScanResult:(NSString*)strResult
{
    if (!strResult) {
        
        strResult = @"识别失败";
    }
    
    __weak __typeof(self) weakSelf = self;
    [LBXAlertAction showAlertWithTitle:@"扫码内容" msg:strResult buttonsStatement:@[@"知道了"] chooseBlock:^(NSInteger buttonIdx) {
        
        [weakSelf reStartDevice];
    }];
}

- (void)showNextVCWithScanResult:(LBXScanResult*)strResult
{
    if ([strResult.strScanned containsString:[ESSLoginTool getMainURL]]) {
//        NSString *liftCode = [strResult.strScanned substringFromIndex:strResult.strScanned.length - 6];
//        ESSLiftDetailController *vc = [[ESSLiftDetailController alloc] initWithBasicInfoID:liftCode];
//        [self.navigationController pushViewController:vc animated:YES];
    }else {
        ESSWebController *vc = [[ESSWebController alloc] initWithURLStr:strResult.strScanned];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
