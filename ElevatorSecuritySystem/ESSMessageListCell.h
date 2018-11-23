//
//  ESSMessageListCell.h
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 16/12/15.
//  Copyright © 2016年 ZhengXinKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ESSMessageListModel.h"

@interface ESSMessageListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *mark;
@property (weak, nonatomic) IBOutlet UILabel *titleText;
@property (weak, nonatomic) IBOutlet UILabel *dateText;
@property (weak, nonatomic) IBOutlet UILabel *detailText;

@end

