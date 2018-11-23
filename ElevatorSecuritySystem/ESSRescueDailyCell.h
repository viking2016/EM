//
//  ESSRescueDailyCell.h
//  ElevatorSecuritySystem
//
//  Created by cz q on 2018/2/23.
//  Copyright © 2018年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESSRescueDailyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contentLb;

@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UIView *line;

@end
