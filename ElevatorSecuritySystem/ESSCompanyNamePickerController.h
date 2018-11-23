//
//  ESSCompanyNamePickerController.h
//  ElevatorSecuritySystem
//
//  Created by cz q on 2017/6/30.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESSCompanyNamePickerController : UIViewController

@property(nonatomic,copy)void(^selectCompanyName)(NSDictionary *);


@end
