//
//  ESSLoginController.h
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2017/4/12.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESSLoginController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *companyIDTextField;

@property (strong, nonatomic) IBOutlet UITextField *accountTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

@end
