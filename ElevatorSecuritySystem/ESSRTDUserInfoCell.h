//
//  ESSRTDUserInfoCell.h
//  ElevatorSecuritySystem
//
//  Created by cz q on 2018/1/30.
//  Copyright © 2018年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESSRTDUserInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *unitNameLab;

@property (weak, nonatomic) IBOutlet UILabel *personLab;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;

@property (copy, nonatomic) NSString *tel;

@end
