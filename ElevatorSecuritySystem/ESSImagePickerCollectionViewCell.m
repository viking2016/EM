//
//  ESSImagePickerCollectionViewCell.m
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2018/7/10.
//  Copyright © 2018年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "ESSImagePickerCollectionViewCell.h"

@implementation ESSImagePickerCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageView.layer.cornerRadius = 3;
    self.imageView.layer.borderWidth = 0.5f;
    self.imageView.layer.borderColor = rgb(239, 239, 239).CGColor;
    self.imageView.layer.masksToBounds = YES;
    // Initialization code
}

@end
