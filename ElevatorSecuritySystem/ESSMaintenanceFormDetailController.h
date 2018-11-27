//
//  ESSMaintenanceFormDetailController.h
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 16/5/28.
//  Copyright © 2016年 ZhengXinKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESSMaintenanceFormDetailController : UIViewController

@property (nonatomic, copy)NSString *workOrderID;
@property (nonatomic, copy)NSString *MCategories;
- (instancetype)initWithWorkOrderID:(NSString *)workOrderID mCategories:(NSString *)mCategories;

@end
