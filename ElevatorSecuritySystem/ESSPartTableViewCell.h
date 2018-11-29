//
//  ESSPartTableViewCell.h
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2018/7/4.
//  Copyright © 2018年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESSRepairModel.h"

@interface ESSPartTableViewCell : UITableViewCell<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UIButton *addPartBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnTrailingConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;
@property (copy, nonatomic) NSString *lbText;
@property (weak, nonatomic) IBOutlet UILabel *lb;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *totalLb;
@property (strong, nonatomic) NSMutableArray<ESSPartReplacemenModel *> *PartReplacemen;
@property (copy, nonatomic) void(^dataArrived)(NSArray<ESSPartReplacemenModel *> *PartReplacemen);

@property (nonatomic, assign) BOOL onlyShow;
@end
