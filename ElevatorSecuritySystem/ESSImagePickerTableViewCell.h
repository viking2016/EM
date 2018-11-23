//
//  ESSImagePickerTableViewCell.h
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2018/7/9.
//  Copyright © 2018年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESSImagePickerTableViewCell : UITableViewCell<UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *lb;
@property (copy, nonatomic) NSString *lbText;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray<UIImage *> *images;
@property (copy, nonatomic) void(^imageSelected)(NSMutableArray<UIImage *> *images);

@end
