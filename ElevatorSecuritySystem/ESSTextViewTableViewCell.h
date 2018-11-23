//
//  ESSTextViewTableViewCell.h
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2018/7/2.
//  Copyright © 2018年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZTextView.h"

@interface ESSTextViewTableViewCell : UITableViewCell <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lb;
@property (copy, nonatomic) NSString *lbText;
@property (weak, nonatomic) IBOutlet  SZTextView *textView;
@property (copy, nonatomic) NSString *tvText;
@property (copy, nonatomic) void(^textViewTextChanged)(NSString *);

@end
