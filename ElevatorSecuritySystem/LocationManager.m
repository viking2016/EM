//
//  LocationManager.m
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2017/6/22.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "LocationManager.h"
#import <CoreLocation/CoreLocation.h>
#import <BaiduMapAPI_Utils/BMKGeometry.h>


@interface LocationManager()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation LocationManager

+ (instancetype)sharedInstance {
    static LocationManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instance) {
            instance = [[LocationManager alloc] init];
        }
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        [self.locationManager requestWhenInUseAuthorization];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = kCLLocationAccuracyHundredMeters;
    }
    return self;
}

- (void)startUpdatingLocation {
    [self.locationManager startUpdatingLocation];
}

- (void)stopUpdatingLocation {
    [self.locationManager stopUpdatingLocation];
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
    
    NSNumber *latitude = [NSNumber numberWithDouble:baiduCoor.latitude];
    NSNumber *longitude = [NSNumber numberWithDouble:baiduCoor.longitude];
    NSDictionary *paras = @{@"Lat":latitude,@"Lon":longitude};
    
    [ESSNetworkingTool POST:@"/APP/RealTimeLocation/Submit" parameters:paras success:^(NSDictionary * _Nonnull responseObject) {
        NSLog(@"定位上传成功%@",paras);
    }];
}

@end
