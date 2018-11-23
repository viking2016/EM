//
//  ESSPageControlCell.h
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2018/7/23.
//  Copyright © 2018年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESSPageControlCell : UICollectionViewCell

@property (copy, nonatomic) NSString *lbTest;
@property (strong, nonatomic) UIImage *selectImg;
@property (strong, nonatomic) UIImage *unselectImg;

@end
