//
//  ESSImagePickerTableViewCell.h
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2018/7/9.
//  Copyright © 2018年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESSImagePickerTableViewCell : UITableViewCell<UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lb;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (copy, nonatomic) NSString *lbText;
@property (strong, nonatomic) NSMutableArray<UIImage *> *images;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (copy, nonatomic) void(^imageChanged)(NSMutableArray<UIImage *> *images);

@end
