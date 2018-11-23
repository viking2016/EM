//
//  ESSRTDLiftInfoCell.m
//  ElevatorSecuritySystem
//
//  Created by cz q on 2018/1/30.
//  Copyright © 2018年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "ESSRTDLiftInfoCell.h"

#import "NavigationManager.h"
#import <CoreLocation/CoreLocation.h>
#import <BaiduMapAPI_Utils/BMKGeometry.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>

@interface ESSRTDLiftInfoCell ()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic,assign)   CLLocationCoordinate2D coordinate;;///记录用户定位位置信息


@end



@implementation ESSRTDLiftInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.lineBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:8];
    
    [self.lineBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:8];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLLocationAccuracyHundredMeters;
    
    [self.locationManager startUpdatingLocation];
}

- (void)setLat:(NSString *)Lat {
    _Lat = Lat;
}

- (void)setLng:(NSString *)Lng {
    _Lng = Lng;
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D coordinate = location.coordinate;
    NSLog(@"纬度:%f 经度:%f", coordinate.latitude, coordinate.longitude);
    
    //转换WGS84坐标至百度坐标(加密后的坐标)
    NSDictionary *testdic = BMKConvertBaiduCoorFrom(coordinate,BMK_COORDTYPE_GPS);
    
    NSLog(@"x=%@,y=%@",[testdic objectForKey:@"x"],[testdic objectForKey:@"y"]);
    //解密加密后的坐标字典
    CLLocationCoordinate2D baiduCoor = BMKCoorDictionaryDecode(testdic);//转换后的百度坐标
    
    //    NSNumber *latitude = [NSNumber numberWithDouble:baiduCoor.latitude];
    //    NSNumber *longitude = [NSNumber numberWithDouble:baiduCoor.longitude];
    self.coordinate = baiduCoor;
    
}

- (IBAction)daoHangEvent:(UIButton *)sender {
    
    CLLocationCoordinate2D coor;
    NSString *endAddress;
    coor = CLLocationCoordinate2DMake([self.Lat doubleValue], [self.Lng doubleValue]);
    
    [[NavigationManager sharedManager] startMapAppNavigationWith:self.coordinate andEndCoor:coor andEndAddress:endAddress];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
