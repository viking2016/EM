//
//  MapPickerController.h
//  ElevatorMaintenanceAssistant
//
//  Created by 刘树龙 on 17/3/17.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>

@interface RWLocation : NSObject

@property (nonatomic,strong)NSString *latitude;

@property (nonatomic,strong)NSString *longitude;

+ (instancetype)locationWithCoordinate:(CLLocationCoordinate2D)coordinate;

@end

@interface MapPickerController : UIViewController

+ (instancetype)mapLocationWithPositionResult:(void(^)(NSDictionary *coordinate))positionResult;

@property (nonatomic,strong)NSString *headerTitle;

//@property (nonatomic,copy)void(^positionResult)(RWLocation *coordinate);
@property (nonatomic,copy)void(^positionResult)(NSDictionary *locationInfo);


@end
