//
//  ESSRTDMapCell.h
//  ElevatorSecuritySystem
//
//  Created by cz q on 2018/1/30.
//  Copyright © 2018年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>

#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Utils/BMKGeometry.h>

#import <MapKit/MapKit.h>
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Map/BMKPolylineView.h>
#import <BaiduMapAPI_Utils/BMKGeometry.h>

@interface RouteAnnotation : BMKPointAnnotation

@end

@interface ESSRTDMapCell : UITableViewCell <BMKMapViewDelegate,BMKLocationServiceDelegate,BMKRouteSearchDelegate>

@property (weak, nonatomic) IBOutlet BMKMapView *mapView;
/** locService对象*/
@property (nonatomic,strong) BMKLocationService *locService;
/** 路线搜索对象 */
@property (nonatomic,strong) BMKRouteSearch *routesearch;

@property (assign,nonatomic) double Lng;
@property (assign,nonatomic) double Lat;
@end
