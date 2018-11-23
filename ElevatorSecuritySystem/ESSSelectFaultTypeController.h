//
//  ESSSelectFaultTypeController.h
//  ElevatorSecuritySystem
//
//  Created by c zq on 16/12/2.
//  Copyright © 2016年 ZhengXinKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^TypeBlock)(NSString *str, NSString *code);

@interface ESSSelectFaultTypeController : UIViewController

@property (assign, nonatomic) int basicInfoID;
@property (copy, nonatomic) TypeBlock block;

@end
