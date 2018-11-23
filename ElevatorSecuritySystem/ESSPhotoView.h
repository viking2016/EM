//
//  ESSPhotoView.h
//  ElevatorSecuritySystem
//
//  Created by cz q on 2017/5/10.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESSPhotoView : UIView

@property (nonatomic,weak) UIImageView *imageView;
@property (nonatomic,weak) UILabel *titleLabel;
@property (nonatomic,strong) NSArray *photoArray;
@property (nonatomic,strong)NSMutableArray *photos;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title images:(NSArray *)images;

@end
