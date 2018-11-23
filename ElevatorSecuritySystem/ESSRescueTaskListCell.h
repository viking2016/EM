//
//  ESSRescueTaskListCell.h
//  ElevatorSecuritySystem
//
//  Created by cz q on 2018/1/29.
//  Copyright © 2018年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESSRescueTaskListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateLb;
@property (weak, nonatomic) IBOutlet UILabel *rescueTypeLb;
@property (weak, nonatomic) IBOutlet UILabel *resultLb;
@property (weak, nonatomic) IBOutlet UILabel *itemLb;
@property (weak, nonatomic) IBOutlet UILabel *addressLb;
@property (weak, nonatomic) IBOutlet UIButton *lineBtn;

@property (strong,nonatomic) NSString *dateStr;
@property (strong,nonatomic) NSString *rescueTypeStr;
@property (strong,nonatomic) NSString *resultStr;
@property (strong,nonatomic) NSString *itemStr;
@property (strong,nonatomic) NSString *addressStr;
@property (strong,nonatomic) NSString *Lng;
@property (strong,nonatomic) NSString *Lat;




@end
