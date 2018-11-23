//
//  ESSSelectFaultReasonController.h
//  ElevatorSecuritySystem
//
//  Created by c zq on 16/11/28.
//  Copyright © 2016年 ZhengXinKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ReasonBlock)(NSString *str, NSString *code);

@interface ESSSelectFaultReasonController : UIViewController

@property (copy, nonatomic) NSString *code;
@property (copy, nonatomic) ReasonBlock block;

@end
