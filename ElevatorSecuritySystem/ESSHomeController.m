//
//  ESSHomeController.m
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2017/4/7.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "ESSImagePickerController.h"

#import "ESSHomeController.h"
#import "ESSHomeCollectionViewCell.h"
#import "ESSVerifyController.h"
#import "ZXWebController.h"

#import "ESSMaintenanceTaskListController.h"
#import "ESSRepairTaskListController.h"
#import "ZXRescueTaskController.h"
#import "ESSRescueTaskListController.h"

#import "ESSSearchController.h"
#import "ESSAddLiftController.h"
#import "ESSLiftManagermentController.h"
#import "ESSMaintenanceFormDetailListController.h"
#import "ESSChuZhiFanKuiController.h"
#import "ESSJiuYuanRiZhiDetailController.h"
#import "ESSAddRepairFormController.h"
#import "ESSRepairFormController.h"
#import "ESSRepairFormDetailListController.h"

#import "ESSHomeTaskButton.h"
#import "SDCycleScrollView.h"
#import <PopMenu.h>
#import <objc/message.h>

@interface ESSHomeController ()<SDCycleScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) SDCycleScrollView *imageCycleView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) SDCycleScrollView *textCycleView;
@property (nonatomic, strong) ESSHomeTaskButton *maintenanceBtn;
@property (nonatomic, strong) ESSHomeTaskButton *repairBtn;
@property (nonatomic, strong) ESSHomeTaskButton *rescueBtn;
@property (nonatomic, strong) ESSHomeTaskButton *nianshenBtn;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *textCycleTitleArr;
//
//@property (nonatomic, strong) NSMutableArray *mNewsURLs;
//@property (nonatomic, strong) NSMutableArray *typeArray;
//@property (nonatomic, strong) NSMutableArray *textCycleURLArr;

@property (nonatomic, strong) NSArray *news;
@property (nonatomic, strong) NSArray *infos;

@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation ESSHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *rightItem = [UIBarButtonItem itemWithTitle:nil image:@"icon_search" highImage:@"icon_search" target:self action:@selector(presentToSearchController)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:layout];
    [self.view addSubview:_collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom).offset(-29);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    
    layout.itemSize = CGSizeMake((SCREEN_WIDTH - 1) / 3, (SCREEN_WIDTH - 1) / 3);
    layout.minimumLineSpacing = 0.5;
    layout.minimumInteritemSpacing = 0.5;
    layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, ((SCREEN_WIDTH * 9 / 16) + 42 + (SCREEN_WIDTH / 4) + 1 + 10));
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
    
    self.collectionView.backgroundColor = rgb(247, 247, 247);
    [self.collectionView registerNib: [UINib nibWithNibName:@"ESSHomeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ESSHomeCollectionViewCell"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.delaysContentTouches = NO;//取消button响应延迟
    self.collectionView.showsVerticalScrollIndicator = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getHomeData) name:@"getHomeData" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([ESSLoginTool isBate]) {
        [self.navigationItem setTitle:@"电梯总管.beta"];
    }else {
        [self.navigationItem setTitle:@"电梯总管"];
    }
    [ESSLoginTool checkVersion];
}

- (NSMutableArray *)datas{
    if (!_datas) {
        NSArray *array = @[@[@"新增电梯",@"bg_shouye_xinzengdianti",@"bg_shouye_xinzengdianti_pre",@"presentAddLiftController"],@[@"电梯管理",@"bg_shouye_diantiguanli",@"bg_shouye_diantiguanli_pre",@"presentLiftManagermentController"],@[@"维保记录",@"bg_shouye_weibaojilu",@"bg_shouye_weibaojilu_pre",@"presentESSMaintenanceFormDetailListController"],@[@"救援记录",@"bg_shouye_jiuyuanjilu",@"bg_shouye_jiuyuanjilu_pre",@"presentESSRescueTaskListController"],@[@"维修申请",@"bg_shouye_weixiushenqing",@"bg_shouye_weixiushenqing_pre",@"prensentESSAddRepairFormController"],@[@"维修记录",@"bg_shouye_weixiu",@"bg_shouye_weixiu_pre",@"prensentESSRepairFormController"]];
        _datas = [array copy];
    }
    return _datas;
}

- (void)getHomeData{
    
    NSString *URLStr = @"/APP/CMS/CMS_News/GetLunBoAndGongGao";
    [NetworkingTool GET:URLStr parameters:@{} success:^(id  _Nonnull responseObject) {
        self.news = responseObject[@"TuPianLunBo"];
        self.infos = responseObject[@"TongZhiGongGao"];
        NSMutableArray *mArr = [NSMutableArray new];
        [self.infos enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull dic, NSUInteger idx, BOOL * _Nonnull stop) {
            [mArr addObject:dic[@"BiaoTi"]];
        }];
        NSArray *arr_BiaoTi = [self.infos valueForKey:@"BiaoTi"];
        self.textCycleView.titlesGroup = arr_BiaoTi;
        self.imageCycleView.titlesGroup = [self.news valueForKey:@"BiaoTi"];
        self.imageCycleView.imageURLStringsGroup = [self.news valueForKey:@"TuPianURL"];
    }];

    [NetworkingTool GET:@"/APP/WB/Elev_Info/GetTaskCount" parameters:nil success:^(NSDictionary * _Nonnull responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            self.maintenanceBtn.numberLabel.text = responseObject[@"MaintTaskCount"];
            self.repairBtn.numberLabel.text = responseObject[@"RepairTaskCount"];
            self.rescueBtn.numberLabel.text = responseObject[@"RescueTaskCount"];
            self.nianshenBtn.numberLabel.text = responseObject[@"AnnualLiftCount"];
        }
    }];
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if (cycleScrollView == _imageCycleView) {
        NSArray *arr = [self.news valueForKey:@"XiangQingURL"];
        ZXWebController *aboutUs = [[ZXWebController alloc] initWithURLStr:arr[index]];
        [self.navigationController pushViewController:aboutUs animated:YES];
    }
    if (cycleScrollView == _textCycleView) {
        NSArray *arr = [self.infos valueForKey:@"XiangQingURL"];
        ZXWebController *aboutUs = [[ZXWebController alloc] initWithURLStr:arr[index]];
        [self.navigationController pushViewController:aboutUs animated:YES];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ESSHomeCollectionViewCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"ESSHomeCollectionViewCell" forIndexPath:indexPath];
    cell.lb.text = [self.datas[indexPath.row] firstObject] ;
    cell.img.image = [UIImage imageNamed:[self.datas[indexPath.row] objectAtIndex:1]];
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    ESSHomeCollectionViewCell* cell = (ESSHomeCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.img.image = [UIImage imageNamed:[self.datas[indexPath.row] objectAtIndex:2]];
}

- (void)collectionView:(UICollectionView *)collectionView  didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    ESSHomeCollectionViewCell* cell = (ESSHomeCollectionViewCell *) [collectionView cellForItemAtIndexPath:indexPath];
    cell.img.image = [UIImage imageNamed:[self.datas[indexPath.row] objectAtIndex:1]];
}

- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];
   
    self.imageCycleView = [[SDCycleScrollView alloc] init];
    [headerView addSubview:_imageCycleView];
    [self.imageCycleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_top);
        make.left.equalTo(headerView.mas_left);
        make.right.equalTo(headerView.mas_right);
        make.height.equalTo(headerView.mas_width).multipliedBy(0.5625f);
    }];
    self.imageCycleView.delegate = self;
    self.imageCycleView.showPageControl = YES;
    self.imageCycleView.backgroundColor = [UIColor whiteColor];
    self.imageCycleView.placeholderImage = [UIImage imageNamed:@"icon_placeHolder.png"];
    self.imageCycleView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    self.imageCycleView.currentPageDotColor = [UIColor whiteColor];
    self.imageCycleView.autoScrollTimeInterval = 5.0f;
    
    
    UIView *bgView = [[UIView alloc] init];
    [headerView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageCycleView.mas_bottom);
        make.left.equalTo(headerView.mas_left);
        make.right.equalTo(headerView.mas_right);
        make.height.equalTo(@42);
    }];
    bgView.backgroundColor = [UIColor whiteColor];
    
    
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_shouye_tongzhigonggao"]];
    [bgView addSubview:_imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@29);
        make.height.equalTo(@22);
        make.centerY.equalTo(bgView.mas_centerY);
        make.left.equalTo(bgView.mas_left).offset(15);
    }];
    
    
    self.textCycleView = [[SDCycleScrollView alloc] init];
    [bgView addSubview:_textCycleView];
    [self.textCycleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@42);
        make.centerY.equalTo(self.imageView.mas_centerY);
        make.left.equalTo(self.imageView.mas_right).offset(15);
        make.right.equalTo(bgView.mas_right).offset(-15);
    }];
    self.textCycleView.delegate = self;
    self.textCycleView.onlyDisplayText = YES;
    self.textCycleView.titleLabelHeight = 16;
    self.textCycleView.backgroundColor = [UIColor whiteColor];
    self.textCycleView.titleLabelBackgroundColor = [UIColor whiteColor];
    self.textCycleView.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.textCycleView.titleLabelTextFont = [UIFont systemFontOfSize:13];
    self.textCycleView.titleLabelTextColor = [UIColor blackColor];
    self.textCycleView.autoScrollTimeInterval = 4.0f;
    
    self.maintenanceBtn = [ESSHomeTaskButton buttonWithNumber:@"0" name:@"维保任务"];
    [headerView addSubview:_maintenanceBtn];
    [self.maintenanceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(headerView.mas_width).multipliedBy(0.25f);
        make.height.equalTo(self.maintenanceBtn.mas_width);
        make.left.equalTo(headerView.mas_left);
        make.top.equalTo(self.textCycleView.mas_bottom).offset(1);
    }];
    [self.maintenanceBtn addTarget:self action:@selector(presentToMaintenanceTaskController) forControlEvents:UIControlEventTouchUpInside];
    
    self.repairBtn = [ESSHomeTaskButton buttonWithNumber:@"0" name:@"维修任务"];
    [headerView addSubview:_repairBtn];
    [self.repairBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.maintenanceBtn.mas_width);
        make.height.equalTo(self.maintenanceBtn.mas_height);
        make.left.equalTo(self.maintenanceBtn.mas_right);
        make.top.equalTo(self.maintenanceBtn.mas_top);
    }];
    [self.repairBtn addTarget:self action:@selector(presentToRepairTaskController) forControlEvents:UIControlEventTouchUpInside];

    self.rescueBtn = [ESSHomeTaskButton buttonWithNumber:@"0" name:@"救援任务"];
    [headerView addSubview:_rescueBtn];
    [self.rescueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.maintenanceBtn.mas_width);
        make.height.equalTo(self.maintenanceBtn.mas_height);
        make.left.equalTo(self.repairBtn.mas_right);
        make.top.equalTo(self.maintenanceBtn.mas_top);
    }];
    [self.rescueBtn addTarget:self action:@selector(rescueBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

    self.nianshenBtn = [ESSHomeTaskButton buttonWithNumber:@"0" name:@"年审电梯"];
    [headerView addSubview:_nianshenBtn];
    [self.nianshenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.maintenanceBtn.mas_width);
        make.height.equalTo(self.maintenanceBtn.mas_height);
        make.left.equalTo(self.rescueBtn.mas_right);
        make.top.equalTo(self.maintenanceBtn.mas_top);
    }];
    [self.nianshenBtn addTarget:self action:@selector(nianshenBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

    UIView *line_0 = [UIView new];
    [headerView addSubview:line_0];
    [line_0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.maintenanceBtn.mas_right).offset(0.5f);
        make.width.equalTo(@1);
        make.top.equalTo(self.maintenanceBtn.numberLabel.mas_top);
        make.bottom.equalTo(self.maintenanceBtn.nameLabel.mas_bottom);
    }];
    line_0.backgroundColor = rgb(229, 229, 229);

    UIView *line_1 = [UIView new];
    [headerView addSubview:line_1];
    [line_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.repairBtn.mas_right).offset(0.5f);
        make.width.equalTo(@1);
        make.top.equalTo(self.repairBtn.numberLabel.mas_top);
        make.bottom.equalTo(self.repairBtn.nameLabel.mas_bottom);
    }];
    line_1.backgroundColor = rgb(229, 229, 229);

    UIView *line_2 = [UIView new];
    [headerView addSubview:line_2];
    [line_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rescueBtn.mas_right).offset(0.5f);
        make.width.equalTo(@1);
        make.top.equalTo(self.rescueBtn.numberLabel.mas_top);
        make.bottom.equalTo(self.rescueBtn.nameLabel.mas_bottom);
    }];
    line_2.backgroundColor = rgb(229, 229, 229);
    return headerView;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *methodName = [self.datas[indexPath.row] lastObject];
    SEL normalSelector = NSSelectorFromString(methodName);
    if ([self respondsToSelector:normalSelector]) {
        ((void (*)(id, SEL))objc_msgSend)(self, normalSelector);
    }
}

#pragma mark - Private method
- (void)presentToSearchController {
    [self.navigationController pushViewController:[ESSSearchController new] animated:YES];
}

- (void)presentToMaintenanceTaskController {
    [self.navigationController pushViewController:[ESSMaintenanceTaskListController new] animated:YES];

}

- (void)presentToRepairTaskController {
    [self.navigationController pushViewController:[ESSRepairTaskListController new] animated:YES];
}

- (void)rescueBtnClicked:(UIButton *)btn {
    [self.navigationController pushViewController:[[ESSRescueTaskListController alloc]initWithControllerType:@"1" elevID:@""] animated:YES];
}

- (void)nianshenBtnClicked:(UIButton *)btn {
    
}

- (void)presentAddLiftController {
    [self.navigationController pushViewController:[ESSAddLiftController new] animated:YES];
}

- (void)presentLiftManagermentController {
    [self.navigationController pushViewController:[ESSLiftManagermentController new] animated:YES];
}

- (void)presentESSMaintenanceFormDetailListController {
    [self.navigationController pushViewController:[ESSMaintenanceFormDetailListController new] animated:YES];
}

- (void)presentESSRescueTaskListController {
    [self.navigationController pushViewController:[[ESSRescueTaskListController alloc]initWithControllerType:@"2" elevID:@""] animated:YES];
}

- (void)prensentESSAddRepairFormController {
    [self.navigationController pushViewController:[ESSAddRepairFormController new] animated:YES];
}

- (void)prensentESSRepairFormController {
    [self.navigationController pushViewController:[ESSRepairFormDetailListController new] animated:YES];
}

- (void)dealloc {
         [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getHomeData" object:nil];
}

@end
