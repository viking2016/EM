//
//  ESSMaintenanceFormDetailListController.h
//  ElevatorSecuritySystem
//
//  Created by c zq on 16/12/9.
//  Copyright © 2016年 ZhengXinKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESSMaintenanceFormDetailListController : UIViewController

@property (nonatomic,copy) NSString *basicInfoID;

- (instancetype)initWithBasicInfoID:(NSString *)basicInfoID;


@end
