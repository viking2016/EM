//
//  ESSRTDLiftInfoCell.h
//  ElevatorSecuritySystem
//
//  Created by cz q on 2018/1/30.
//  Copyright © 2018年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESSRTDLiftInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *lineBtn;
@property (weak, nonatomic) IBOutlet UILabel *rescueIdLab;
@property (weak, nonatomic) IBOutlet UILabel *locationLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UILabel *liftTypeLab;

@property (strong,nonatomic) NSString *Lng;
@property (strong,nonatomic) NSString *Lat;

@end
