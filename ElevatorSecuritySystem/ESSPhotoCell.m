//
//  ESSPhotoCell.m
//  ElevatorSecuritySystem
//
//  Created by cz q on 2018/2/1.
//  Copyright © 2018年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "ESSPhotoCell.h"

@implementation ESSPhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.layer.cornerRadius = 2;
    self.layer.borderColor = rgb(239, 239, 239).CGColor;
    self.layer.borderWidth = 0.5f;
}

@end
