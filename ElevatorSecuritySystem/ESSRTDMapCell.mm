//
//  ESSRTDMapCell.m
//  ElevatorSecuritySystem
//
//  Created by cz q on 2018/1/30.
//  Copyright © 2018年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//
//    pt_start = (CLLocationCoordinate2D) {36.097318, 120.376536};  //青岛银行
//    pt_end = (CLLocationCoordinate2D) {36.093749, 120.38132};     //市北区政府



#import "ESSRTDMapCell.h"

#import "ESSStartingPointAnnotation.h"
#import "ESSTerminalPointAnnotation.h"
#import "ESSLocationAnnotation.h"

@implementation ESSRTDMapCell


- (void)setLat:(double)Lat {
    _Lat = Lat;
}
- (void)setLng:(double)Lng {
    _Lng = Lng;
    
    _mapView.delegate = self;
    
    _routesearch = [[BMKRouteSearch alloc] init];
    _routesearch.delegate = self;
    [self getUserLocation];
    self.mapView.showsUserLocation = NO;//蓝圈
    // 设置定位模式
    self.mapView.userTrackingMode = BMKUserTrackingModeFollow;//定位跟随模式
}

#pragma mark -- 定位功能
- (void)getUserLocation
{
    _locService = [[BMKLocationService alloc]init];
    _locService.distanceFilter = 5.0;//设置定位的最小距离
    //启动LocationService
    _locService.delegate = self;
    [_locService startUserLocationService];
}

//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    NSArray *annotations=[_mapView annotations];
    if (annotations) {
        for (BMKPointAnnotation *annotation in annotations){
            if ([annotation isKindOfClass:[ESSLocationAnnotation class]]) {
                [_mapView removeAnnotation:annotation];
            }
        }
    }
    ESSLocationAnnotation *point = [[ESSLocationAnnotation alloc] init];
    point.coordinate = _locService.userLocation.location.coordinate;
    //    point.title = title;
    [self.mapView addAnnotation:point];
//    [_locService stopUserLocationService];//需要停止定位，否则创建大头针的时候会不断的添加
}


//自定义大头针
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation{
    if ([annotation isKindOfClass:[ESSStartingPointAnnotation class]]) {
//        ESSStartingPointAnnotation *startAnnotation=(ESSStartingPointAnnotation *)annotation;
        BMKAnnotationView *newAnnotationView=(BMKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"start"];
        if (!newAnnotationView) {
            newAnnotationView= [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"chewei"];
            newAnnotationView.canShowCallout=NO;
            newAnnotationView.image=[UIImage imageNamed:@"icon_jiuyuanrenwuxiangqing_chufadian"];
        }
        return newAnnotationView;
    }else if ([annotation isKindOfClass:[ESSTerminalPointAnnotation class]]) {
        BMKAnnotationView *newAnnotationView=(BMKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"terminal"];
        if (!newAnnotationView) {
            newAnnotationView= [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"terminal"];
            newAnnotationView.canShowCallout=NO;
            newAnnotationView.image=[UIImage imageNamed:@"icon_jiuyuanrenwuxiangqing_baojingdian"];
        }
        return newAnnotationView;
    }else if ([annotation isKindOfClass:[ESSLocationAnnotation class]]){
        BMKAnnotationView *newAnnotationView=(BMKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"location"];
        if (!newAnnotationView) {
            newAnnotationView= [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"location"];
            newAnnotationView.canShowCallout=NO;
            newAnnotationView.image=[UIImage imageNamed:@"icon_jiuyuanrenwuxiangqing_touxiang"];
        }
        return newAnnotationView;
    }
    return nil;
}

/**
 *  @author Mask
 *
 *  @brief 地图加载完全后 第一次获取数据  貌似只会调用一次
 *
 *  @param mapView <#mapView description#>
 */
- (void)mapViewDidFinishLoading:(BMKMapView *)mapView{
    if (_locService) {
        //    //构造驾车查询基础信息类
        BMKPlanNode* start = [[BMKPlanNode alloc]init];
//        start.cityName = @"青岛市";
        
        BMKPlanNode* end = [[BMKPlanNode alloc]init];
//        end.cityName = @"青岛市";
        CLLocationCoordinate2D pt_start = (CLLocationCoordinate2D){0, 0};//初始化
        CLLocationCoordinate2D pt_end = (CLLocationCoordinate2D){0, 0};//初始化
        
        if (_locService.userLocation.location.coordinate.longitude!= 0 && _locService.userLocation.location.coordinate.latitude!= 0) { //如果还没有给pt赋值,那就将当前的经纬度赋值给pt
            pt_start = (CLLocationCoordinate2D) {_locService.userLocation.location.coordinate.latitude, _locService.userLocation.location.coordinate.longitude};
        }
        if (self.Lng!= 0 && self.Lat!= 0) {
            pt_end = (CLLocationCoordinate2D) {_Lat, _Lng};
        }
        start.pt = pt_start;
        end.pt = pt_end;
        BMKDrivingRoutePlanOption *drivingRouteSearchOption = [[BMKDrivingRoutePlanOption alloc]init];
        drivingRouteSearchOption.from = start;
        drivingRouteSearchOption.to = end;
        drivingRouteSearchOption.drivingRequestTrafficType = BMK_DRIVING_REQUEST_TRAFFICE_TYPE_NONE;//不获取路况信息
        BOOL flag = [_routesearch drivingSearch:drivingRouteSearchOption];
        if(flag)
        {
            NSLog(@"******************  car检索发送成功 *************");
        }
        else
        {
            NSLog(@"***************** car检索发送失败 ***************");
        }
    }
}

- (void)mapViewDidFinishRendering:(BMKMapView *)mapView {
    
}
#pragma mark -- 路径规划
- (void)onGetDrivingRouteResult:(BMKRouteSearch *)searcher result:(BMKDrivingRouteResult *)result errorCode:(BMKSearchErrorCode)error {
    BMKDrivingRouteLine* plan = (BMKDrivingRouteLine*)[result.routes objectAtIndex:0];
    // 计算路线方案中的路段数目
    int size = (int)[plan.steps count];
    int planPointCounts = 0;
    for (int i = 0; i < size; i++) {
        BMKDrivingStep *tansitStep = [plan.steps objectAtIndex:i];
        if (i == 0 ) {
            ESSStartingPointAnnotation* annotation = [[ESSStartingPointAnnotation alloc]init];
            annotation.coordinate = plan.starting.location;
            annotation.title = @"起点";
            [_mapView addAnnotation:annotation];
            
        } else if (i == size - 1) {
            ESSTerminalPointAnnotation* annotation = [[ESSTerminalPointAnnotation alloc]init];
            annotation.coordinate = plan.terminal.location;
            annotation.title = @"终点";
            [_mapView addAnnotation:annotation];
        }
        
        BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
        annotation.coordinate =  tansitStep.entrace.location; //路段入口信息
        annotation.title = tansitStep.instruction; //路程换成说明
//        [_mapView addAnnotation:annotation];
        //轨迹点总数累计
        planPointCounts += tansitStep.pointsCount;
    }
    //轨迹点
    BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts]; //文件后缀名改为mm
    int i = 0;
    for (int j = 0; j < size; j++) {
        BMKTransitStep *transitStep = [plan.steps objectAtIndex:j];
        int k = 0;
        for (k = 0; k < transitStep.pointsCount; k++) {
            temppoints[i].x = transitStep.points[k].x;
            temppoints[i].y = transitStep.points[k].y;
            i++;
        }
    }
    //通过points构建BMKPolyline
    BMKPolyline *polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
    [_mapView addOverlay:polyLine]; //添加路线overlay
    delete []temppoints;
    [self mapViewFitPolyLine:polyLine];
}

////根据polyline设置地图范围
- (void)mapViewFitPolyLine:(BMKPolyline *) polyLine {
    CGFloat ltX, ltY, rbX, rbY;
    if (polyLine.pointCount < 1) {
        return;
    }
    BMKMapPoint pt = polyLine.points[0];
    ltX = pt.x;ltY = pt.y;
    rbX = pt.x;rbY = pt.y;
    for (int i = 1; i < polyLine.pointCount; i++) {
        BMKMapPoint pt = polyLine.points[i];
        if (pt.x < ltX) {
            ltX = pt.x;
        }
        if (pt.x > rbX) {
            rbX = pt.x;
        }
        if (pt.y > ltY) {
            ltY = pt.y;
        }
        if (pt.y < rbY) {
            rbY = pt.y;
        }
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(ltX , ltY);
    rect.size = BMKMapSizeMake(rbX - ltX, rbY - ltY);
    [_mapView setVisibleMapRect:rect];
    _mapView.zoomLevel = _mapView.zoomLevel - 0.3;
}

#pragma mark -- 路线线条绘制代理
- (BMKOverlayView *)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay {
    if ([overlay isKindOfClass:[BMKPolyline class]]){
        BMKPolylineView *polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        //设置线条颜色
        polylineView.fillColor = MAINCOLOR;
        polylineView.strokeColor = MAINCOLOR;
        polylineView.lineWidth = 2.0;
        polylineView.lineDash = YES;
        return polylineView;
        
    } return nil;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
