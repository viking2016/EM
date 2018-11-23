 //
//  ESSRescueTaskListCell.m
//  ElevatorSecuritySystem
//
//  Created by cz q on 2018/1/29.
//  Copyright © 2018年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "ESSRescueTaskListCell.h"
#import "NavigationManager.h"
#import <CoreLocation/CoreLocation.h>
#import <BaiduMapAPI_Utils/BMKGeometry.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>



@interface ESSRescueTaskListCell ()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic,assign)   CLLocationCoordinate2D coordinate;;///记录用户定位位置信息


@end



@implementation ESSRescueTaskListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.height - 4)];
    self.selectedBackgroundView = view;
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.rescueTypeLb.layer.cornerRadius = 2;
    self.rescueTypeLb.layer.borderWidth = 1;
    self.resultLb.layer.cornerRadius = 2;
    self.resultLb.layer.borderWidth = 1;
    
    [self.lineBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:8];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLLocationAccuracyHundredMeters;
    
    [self.locationManager startUpdatingLocation];
}

- (void)setDateStr:(NSString *)dateStr{
    _dateStr = dateStr;
    _dateLb.text =_dateStr;
}

- (void)setRescueTypeStr:(NSString *)rescueTypeStr{
    _rescueTypeStr = rescueTypeStr;
    
    if ([_rescueTypeStr isEqualToString:@"一级救援"]) {
        self.rescueTypeLb.textColor = RGBA(252, 177, 32, 1);
        self.rescueTypeLb.layer.borderColor = RGBA(252, 177, 32, 1).CGColor;
    }else {
        self.rescueTypeLb.textColor = [UIColor redColor];
        self.rescueTypeLb.layer.borderColor = [UIColor redColor].CGColor;
    }
    _rescueTypeLb.text = _rescueTypeStr;
}

- (void)setResultStr:(NSString *)resultStr{
    _resultStr = resultStr;
    if ([_resultStr isEqualToString:@"救援失败"]){
        self.resultLb.textColor = [UIColor redColor];
        self.resultLb.layer.borderColor = [UIColor redColor].CGColor;
        }else {
    self.resultLb.textColor = RGBA(1, 176, 1, 1);
    self.resultLb.layer.borderColor = RGBA(66, 188, 66, 1).CGColor;
    }
    _resultLb.text = _resultStr;
}

- (void)setItemStr:(NSString *)itemStr{
    _itemStr = itemStr;
    _itemLb.text = _itemStr;
}

- (void)setAddressStr:(NSString *)addressStr{
    _addressStr = addressStr;
    _addressLb.text = _addressStr;
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

}

@end
