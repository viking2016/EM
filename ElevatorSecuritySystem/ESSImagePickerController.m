//
//  ESSImagePickerController.m
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2018/7/25.
//  Copyright © 2018年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "ESSImagePickerController.h"
#import "LxGridViewFlowLayout.h"

@interface ESSImagePickerController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) UICollectionView *collection;
@property (strong, nonatomic) LxGridViewFlowLayout *flowLayout;

@end

@implementation ESSImagePickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.flowLayout = [LxGridViewFlowLayout new];
    self.collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:self.flowLayout];
    
    [self.view addSubview:self.collection];
}


@end
