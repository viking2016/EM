//
//  LocationPickerController.h
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 16/7/25.
//  Copyright © 2016年 ZhengXinKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LocationPickerStyle) {
    LocationPickerStyleProvince,
    LocationPickerStyleCity,
    LocationPickerStyleCounty,
    LocationPickerStyleStreet
};

typedef void(^LocationPickerBlock)(NSDictionary *value);

@interface LocationPickerController : UITableViewController

- (instancetype)initWithStyle:(LocationPickerStyle)style valueSelected:(LocationPickerBlock)valueSelected;

@property (copy, nonatomic) LocationPickerBlock valueSelected;
@property (nonatomic, assign) LocationPickerStyle style;

@end
