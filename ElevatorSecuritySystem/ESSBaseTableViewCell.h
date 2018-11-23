//
//  ESSBaseTableViewCell.h
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2018/6/29.
//  Copyright © 2018年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESSBaseTableViewCell : UITableViewCell


@property (copy, nonatomic) NSString *lbText;
@property (copy, nonatomic) NSString *detailLbText;
@property (weak, nonatomic) IBOutlet UILabel *lb;
@property (weak, nonatomic) IBOutlet UILabel *detailLb;

@end
