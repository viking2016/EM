//
//  ZXRescueTaskCell.h
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 16/8/15.
//  Copyright © 2016年 ZhengXinKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXRescueTaskCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *leadingImage;
@property (weak, nonatomic) IBOutlet UILabel *leadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *trailingImage;


@end
