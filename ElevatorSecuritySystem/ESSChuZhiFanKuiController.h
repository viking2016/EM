//
//  ESSChuZhiFanKuiController.h
//  ElevatorSecuritySystem
//
//  Created by cz q on 2018/1/31.
//  Copyright © 2018年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESSChuZhiFanKuiController : UIViewController

@property (nonatomic, copy) NSString *rescueId;
@property (nonatomic, assign) int basicInfoID;

- (instancetype)initWithRescueId:(NSString *)rescueId;

@property(nonatomic,copy)void(^submitCallback)(NSString *);

@end
