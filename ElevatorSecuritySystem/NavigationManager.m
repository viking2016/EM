//
//  NavigationManager.m
//  KangLian
//
//  Created by goodsrc_jzw on 15/11/18.
//  Copyright © 2015年 Mask. All rights reserved.
//

#import "NavigationManager.h"

@interface NavigationManager()<UIActionSheetDelegate>{
    CLLocationCoordinate2D _startCoor;
    CLLocationCoordinate2D _endCoor;
    NSString *_endAddress;
}

@end


@implementation NavigationManager

+ (NavigationManager *)sharedManager{
    static NavigationManager *shared=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared=[[NavigationManager alloc]init];
    });
    return shared;
}

- (id)init{
    if (self=[super init]) {
        
    }
    return self;
}

- (void)startMapAppNavigationWith:(CLLocationCoordinate2D)startCoor andEndCoor:(CLLocationCoordinate2D)endCoor andEndAddress:(NSString *)endAdress{
    _startCoor=startCoor;
    _endCoor=endCoor;
    _endAddress=endAdress;
    UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:@"导航" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"百度地图",@"苹果地图", nil];
    [sheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==2) {
        return;
    }
    if (buttonIndex==0) {
        //百度地图
        BMKPlanNode *startPoint=[[BMKPlanNode alloc]init];
        startPoint.name=@"我的位置";
        startPoint.pt=_startCoor;
        
        BMKPlanNode *endPoint=[[BMKPlanNode alloc]init];
        endPoint.name=_endAddress;
        endPoint.pt=_endCoor;
        
        BMKNaviPara *naviPara=[[BMKNaviPara alloc]init];
        naviPara.startPoint=startPoint;
        naviPara.endPoint=endPoint;
        naviPara.appScheme=@"baidumap://com.citzx.ElevatorSecuritySystem";
        naviPara.appName=@"电梯总管";
        naviPara.isSupportWeb=YES;

        [BMKNavigation openBaiduMapNavigation:naviPara];
    }else{
        _endCoor=[self GCJ02FromBD09:_endCoor];
        MKMapItem *currentLocation=[MKMapItem mapItemForCurrentLocation];
        MKPlacemark *placemark=[[MKPlacemark alloc]initWithCoordinate:_endCoor addressDictionary:nil];
        MKMapItem *toItem=[[MKMapItem alloc]initWithPlacemark:placemark];
        toItem.name=_endAddress;
        [MKMapItem openMapsWithItems:@[currentLocation,toItem] launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
    }
}

/// 百度坐标转高德坐标
- (CLLocationCoordinate2D)GCJ02FromBD09:(CLLocationCoordinate2D)coor
{
    CLLocationDegrees x_pi = 3.14159265358979324 * 3000.0 / 180.0;
    CLLocationDegrees x = coor.longitude - 0.0065, y = coor.latitude - 0.006;
    CLLocationDegrees z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi);
    CLLocationDegrees theta = atan2(y, x) - 0.000003 * cos(x * x_pi);
    CLLocationDegrees gg_lon = z * cos(theta);
    CLLocationDegrees gg_lat = z * sin(theta);
    return CLLocationCoordinate2DMake(gg_lat, gg_lon);
}

@end
