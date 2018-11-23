//
//  ESSRepairFormDetailHeader.m
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2018/7/13.
//  Copyright © 2018年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "ESSRepairFormDetailHeader.h"
#import "ESSPageControlCell.h"

@interface ESSRepairFormDetailHeader()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) UICollectionViewFlowLayout *layout;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray<NSString *> *selectedStates;

@end

@implementation ESSRepairFormDetailHeader

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.selectedStates = [@[@"1",@"0",@"0"] mutableCopy];
        self.datas = @[@[@"维修信息",@"pic_weixiujiluxiangqing_weixiuxinxi",@"pic_weixiujiluxiangqing_weixiuxinxi2"],@[@"零部件更换详情",@"pic_weixiujiluxiangqing_lingbujiangenghuan",@"pic_weixiujiluxiangqing_lingbujiangenghuan2"],@[@"客户评价",@"pic_weixiujiluxiangqing_kehupingjia",@"pic_weixiujiluxiangqing_kehupingjia2"]];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    self.layout = [UICollectionViewFlowLayout new];
//    self.layout.itemSize = CGSizeMake(SCREEN_WIDTH / 3, 36);
    self.layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.layout.minimumLineSpacing = 0;
    self.layout.minimumInteritemSpacing = 0;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 36) collectionViewLayout:self.layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ESSPageControlCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([ESSPageControlCell class])];
    [self addSubview:self.collectionView];
    
//    NSInteger padding = 0;
//    self.repairInfoBtn = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ESSPageControl class]) owner:self options:nil] lastObject];
//    self.repairInfoBtn.backgroundColor = [UIColor redColor];
//    [self addSubview:self.repairInfoBtn];
//
//    self.partReplacementBtn = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ESSPageControl class]) owner:self options:nil] lastObject];
//    [self addSubview:self.partReplacementBtn];
//
//    self.evalutionBtn = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ESSPageControl class]) owner:self options:nil] lastObject];
//    [self addSubview:self.evalutionBtn];
//
//    [@[self.repairInfoBtn, self.partReplacementBtn, self.evalutionBtn] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:padding leadSpacing:padding tailSpacing:padding];
//
//    [@[self.repairInfoBtn, self.partReplacementBtn, self.evalutionBtn] mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self);
//        make.height.equalTo(@36);
//    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ESSPageControlCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ESSPageControlCell class]) forIndexPath:indexPath];
    cell.lbTest = [self.datas[indexPath.row] firstObject];
    cell.selectImg = [UIImage imageNamed:self.datas[indexPath.row][1]];
    cell.unselectImg = [UIImage imageNamed:[self.datas[indexPath.row] lastObject]];
    if ([self.selectedStates[indexPath.row] isEqualToString:@"1"]) {
        cell.selected = YES;
    }else {
        cell.selected = NO;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.callBack(indexPath);
    [self.selectedStates replaceObjectAtIndex:0 withObject:@"0"];
    [self.selectedStates replaceObjectAtIndex:1 withObject:@"0"];
    [self.selectedStates replaceObjectAtIndex:2 withObject:@"0"];
    [self.selectedStates replaceObjectAtIndex:indexPath.row withObject:@"1"];
    [self.collectionView reloadData];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            return CGSizeMake(SCREEN_WIDTH * 0.3, 36);
        }
            break;
        case 1:
        {
            return CGSizeMake(SCREEN_WIDTH * 0.4, 36);
        }
            break;
        default:
        {
            return CGSizeMake(SCREEN_WIDTH * 0.3, 36);
        }
            break;
    }
}
@end
