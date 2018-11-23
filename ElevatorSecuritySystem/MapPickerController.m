//
//  MapPickerController.m
//  ElevatorMaintenanceAssistant
//
//  Created by 刘树龙 on 17/3/17.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co., Ltd. All rights reserved.
//

#import "MapPickerController.h"
#import <MJExtension.h>

@implementation RWLocation

+ (instancetype)locationWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    RWLocation *location = [[RWLocation alloc] init];
    
    location.latitude = [NSString stringWithFormat:@"%lf",coordinate.latitude];
    location.longitude = [NSString stringWithFormat:@"%lf",coordinate.longitude];
    
    return location;
}

@end

CLLocationCoordinate2D get_coordinate(RWLocation *location)
{
    CLLocationCoordinate2D coordinate;
    
    coordinate.longitude = location.longitude.length?location.longitude.doubleValue:NSNotFound;
    coordinate.latitude = location.latitude.length?location.latitude.doubleValue:NSNotFound;
    
    return coordinate;
}


@interface MapPickerController ()

<
BMKMapViewDelegate,
BMKGeoCodeSearchDelegate,
BMKLocationServiceDelegate
>

@property (nonatomic,strong)BMKPointAnnotation* annotation;

@property (nonatomic,strong)BMKMapView *map;

@property (nonatomic,strong)BMKLocationService *location;

@property (nonatomic,strong)BMKGeoCodeSearch *search;

@property (nonatomic,copy)NSString *address;

@property (nonatomic, strong) CLGeocoder *geoC;

@property (nonatomic,strong) UILabel *addressLab;

@property (nonatomic,strong)NSMutableDictionary *dictSource;

@end

@implementation MapPickerController

+(instancetype)mapLocationWithPositionResult:(void (^)(NSDictionary *))positionResult{
    MapPickerController *mapViewController = [[MapPickerController alloc] init];
    mapViewController.positionResult = positionResult;
    
    return mapViewController;
}


#pragma mark -懒加载
-(CLGeocoder *)geoC
{
    if (!_geoC) {
        _geoC = [[CLGeocoder alloc] init];
    }
    return _geoC;
}

-(NSMutableDictionary *)dictSource
{
    if (!_dictSource) {
        _dictSource = [[NSMutableDictionary alloc] init];
    }
    return _dictSource;
}

// - (BMKGeoCodeSearch *)search {
//     if (_search == nil) {
//         _search =[[BMKGeoCodeSearch alloc]init];
//         _search.delegate = self;
//     }
//     return _search;
// }

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    
    if (error == 0) {
        if (result)
        {
            _map.centerCoordinate = result.location;
            _address = result.address;
            BMKAddressComponent *addressDetail = result.addressDetail;
            NSString *recvAddress = [NSString stringWithFormat:@"%@%@%@%@%@",addressDetail.province,addressDetail.city,addressDetail.district, addressDetail.streetName, addressDetail.streetNumber];
            self.addressLab.text = recvAddress;
            NSDictionary *dict = [addressDetail mj_keyValues];
            [self.dictSource addEntriesFromDictionary:dict];
        }
    }
}

- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (result)
    {
        _map.centerCoordinate = result.location;
    }
}

//完成微调
- (void)finishMakeCoordinate
{
    
    if (!(self.addressLab.text.length > 0)){
        [SVProgressHUD showInfoWithStatus:@"正在加载"];
        return;
    }
    RWLocation *location = [RWLocation locationWithCoordinate:_annotation.coordinate];
    
    [self.dictSource setObject:location forKey:@"RWLocation"];
    
    if (_positionResult)
    {
        _positionResult(self.dictSource);
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"first" object:nil userInfo:self.dictSource];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)setHeaderTitle:(NSString *)headerTitle
{
    _headerTitle = headerTitle;
    
    self.navigationItem.title = _headerTitle;
}

- (void)initNavigationBar
{
    
}

- (void)initMap
{
    _map = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _map.showsUserLocation = YES;
    _map.userTrackingMode = BMKUserTrackingModeFollow;
    _map.zoomLevel = 18;
    _map.minZoomLevel = 15;
    [self.view addSubview:_map];
    
    _annotation = [[BMKPointAnnotation alloc]init];
    _annotation.coordinate = _map.centerCoordinate;
    [_map addAnnotation:_annotation];
    
    _location = [[BMKLocationService alloc] init];
    [_location startUserLocationService];
    
    _search =[[BMKGeoCodeSearch alloc]init];
    
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    [_map setCenterCoordinate:userLocation.location.coordinate];
    [_location stopUserLocationService];
    
    NSLog(@"userLocation：%@",userLocation);
}

/**
 *  @author Mask, 16-09-05 15:09:53
 *
 *  @brief 地图区域完全改变后 重新获取数据
 *

 */
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    CLLocationCoordinate2D pt = self.map.centerCoordinate;
//    NSLog(@"pt：%@",pt);

    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [self.search reverseGeoCode:reverseGeoCodeSearchOption];
    if(flag){
        NSLog(@"反geo检索发送成功");

    } else {
        NSLog(@"反geo检索发送失败");
    }
    
}

- (void)mapView:(BMKMapView *)mapView onDrawMapFrame:(BMKMapStatus *)status
{
    _annotation.coordinate = mapView.centerCoordinate;
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"地图标注";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initMap];
//    [self initNavigationBar];
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 60 - 64, SCREEN_WIDTH, 60)];
    [self.view addSubview:bottomView];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view bringSubviewToFront:bottomView];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 20, 20, 20)];
    [bottomView addSubview:imageView];
    imageView.contentMode =  UIViewContentModeScaleAspectFit;
    [imageView setImage:[UIImage imageNamed:@"icon_add_gps"]];
    
    self.addressLab = [[UILabel alloc]initWithFrame:CGRectMake(50, 20, SCREEN_WIDTH-130, 20)];
    [bottomView addSubview:_addressLab];
    _addressLab.font = [UIFont systemFontOfSize:14];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 85, 15, 70, 30)];
    [bottomView addSubview:button];
    button.backgroundColor = MAINCOLOR;
    [button setTitle:@"确认选点" forState:UIControlStateNormal];
    button.layer.cornerRadius = 3;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button addTarget:self action:@selector(finishMakeCoordinate) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_map viewWillAppear];
    _map.delegate = self;
    _location.delegate = self;
    _search.delegate = self;

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_map viewWillDisappear];
    _map.delegate = nil;
    _location.delegate = nil;
    _search.delegate = nil;

}

@end
