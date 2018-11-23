//
//  ESSImagePickerTableViewCell.m
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2018/7/9.
//  Copyright © 2018年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "ESSImagePickerTableViewCell.h"
#import "ESSImagePickerCollectionViewCell.h"
#import <TZImagePickerController.h>

@interface ESSImagePickerTableViewCell()<TZImagePickerControllerDelegate>

@end

@implementation ESSImagePickerTableViewCell
{
    float width;
    float height;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    width = SCREEN_WIDTH / 2 - 15;
    height = width / 16 * 9;
    self.heightConstraint.constant = height;
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ESSImagePickerCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([ESSImagePickerCollectionViewCell class])];
}

- (void)setLbText:(NSString *)lbText {
    NSString *lastChar = [lbText substringFromIndex:lbText.length - 1];
    if ([lastChar isEqualToString:@"*"]) {
        NSMutableAttributedString * tempString = [[NSMutableAttributedString alloc] initWithString: lbText];
        [tempString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(lbText.length - 1, 1)];
        self.lb.attributedText = tempString;
    }else {
        self.lb.text = lbText;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.images.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ESSImagePickerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ESSImagePickerCollectionViewCell class]) forIndexPath:indexPath];
    if (indexPath.row == self.images.count) {
        cell.imageView.image = [UIImage imageNamed:@"icon_weixiudan_paizhao"];
        cell.imageView.contentMode = UIViewContentModeCenter;
    }else {
        cell.imageView.image = self.images[indexPath.row];
        cell.imageView.contentMode = UIViewContentModeScaleToFill;
    }
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(width, height);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (indexPath.row == self.images.count) {
        self.collectionView.height = (self.images.count / 2 + 1) * (height + 15);

        [self.images addObject:[UIImage imageNamed:@"icon_weixiudan_paizhao"]];
//        TZImagePickerController *vc = [[TZImagePickerController alloc] initWithMaxImagesCount:(9 - self.images.count) delegate:self];
//        [self.viewController presentViewController:vc animated:YES completion:^{
//
//        }];
    }
    else {
        [self.images removeObjectAtIndex:indexPath.row];
        self.collectionView.height = (self.images.count / 2 + 1) * (height + 15);
        self.imageSelected(self.images);
        [self.collectionView reloadData];
    }
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    [self.images addObjectsFromArray:photos];
    self.collectionView.height = (self.images.count / 2 + 1) * (height + 15);
//    [self.collectionView reloadData];
    self.imageSelected(self.images);
}

@end
