//
//  ESSLiftManagermentCell.h
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2017/4/27.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ESSProgressView.h"
#import "ESSLiftManagerProjectModel.h"

@interface ESSLiftManagermentCell : UITableViewCell

NS_ASSUME_NONNULL_BEGIN

@property (weak, nonatomic) IBOutlet UIButton *typeBtn;
@property (weak, nonatomic) IBOutlet UILabel *innerLb;
@property (strong, nonatomic) ESSProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIImageView *faultIcon;

- (void)setItem:(ESSLiftManagerLiftDetailModel *)item;

NS_ASSUME_NONNULL_END

@end
