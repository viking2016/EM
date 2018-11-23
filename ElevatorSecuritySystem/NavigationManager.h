//
//  NavigationManager.h
//  KangLian
//
//  Created by goodsrc_jzw on 15/11/18.
//  Copyright © 2015年 Mask. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <MapKit/MapKit.h>
/**
 *  @author Mask, 16-09-06 14:09:31
 *
 *  @brief 导航类
 */
@interface NavigationManager : NSObject

+ (NavigationManager *)sharedManager;

/**
 *  @author Mask, 16-09-06 14:09:45
 *
 *  @brief 导航
 *
 *  @param startCoor 起点
 *  @param endCoor   终点
 *  @param endAdress 终点名称
 */
- (void)startMapAppNavigationWith:(CLLocationCoordinate2D)startCoor andEndCoor:(CLLocationCoordinate2D)endCoor andEndAddress:(NSString *)endAdress;

//- (void)startNavigationWith:(CLLocationCoordinate2D)startCoor andEndCoor:(CLLocationCoordinate2D)endCoor;

@end
