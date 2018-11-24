//
//  ESSJiuYuanRiZhiDetailController.m
//  ElevatorSecuritySystem
//
//  Created by cz q on 2018/1/31.
//  Copyright © 2018年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "ESSJiuYuanRiZhiDetailController.h"
#import "MWPhoto.h"
#import "MWPhotoBrowser.h"
#import "ESSPhotoCell.h"

@interface ESSJiuYuanRiZhiDetailController ()<UICollectionViewDelegate,UICollectionViewDataSource,MWPhotoBrowserDelegate>
{
    CGFloat  _itemWH ;
}
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UILabel *result_Lab;
@property (nonatomic,strong) UILabel *content_Lab;
@property (nonatomic,strong) UILabel *time_Lab;
@property (nonatomic,strong) UILabel *user_Lab;
@property (nonatomic,strong) UILabel *zhaiYao_Lab;
@property (nonatomic,strong) UILabel *photo_TitleLab;

@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableArray *photos;



@end

@implementation ESSJiuYuanRiZhiDetailController

- (instancetype)initWithLogId:(NSString *)logId {
    self = [super init];
    if (self) {
        self.LogId = logId;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"救援日志详情";
    self.view.backgroundColor = RGBA(242, 242, 242, 1);
    self.dataArray = [[NSMutableArray alloc]init];
    
    UIView *baseView = [[UIView alloc]init];
    [self.view addSubview:baseView];
    baseView.backgroundColor = [UIColor whiteColor];
    
    
    
    UILabel *result_TitleLab = [[UILabel alloc]init];
    [baseView addSubview:result_TitleLab];
    result_TitleLab.text = @"结果：";
    result_TitleLab.font = [UIFont systemFontOfSize:13];
    result_TitleLab.textColor = RGBA(51, 51, 51, 1);
    [result_TitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(baseView.mas_left).offset(29);
        make.top.equalTo(baseView.mas_top).offset(20);
    }];
    
    self.result_Lab = [[UILabel alloc]init];
    [baseView addSubview:_result_Lab];
//    _result_Lab.text = @"  ";
    _result_Lab.numberOfLines = 0;
    _result_Lab.textColor = RGBA(102, 102, 102, 1);
    _result_Lab.textAlignment = 0;
    _result_Lab.font = [UIFont systemFontOfSize:13];
    [_result_Lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(result_TitleLab.mas_right).offset(0);
        make.top.equalTo(baseView.mas_top).offset(20);
        make.right.equalTo(baseView.mas_right).offset(-15);
    }];
    
    UILabel *content_TiteleLab = [[UILabel alloc]init];
    [baseView addSubview:content_TiteleLab];
    content_TiteleLab.textColor = RGBA(51, 51, 51, 1);
    content_TiteleLab.text = @"内容：";
    content_TiteleLab.font = [UIFont systemFontOfSize:13];
    [content_TiteleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(baseView.mas_left).offset(29);
        make.top.equalTo(_result_Lab.mas_bottom).offset(14);
    }];

   self.content_Lab = [[UILabel alloc]init];
//    _content_Lab.text = @"  ";
    [baseView addSubview:_content_Lab];
    _content_Lab.numberOfLines = 0;
    _content_Lab.textColor = RGBA(102, 102, 102, 1);
    _content_Lab.font = [UIFont systemFontOfSize:13];
    [_content_Lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(content_TiteleLab.mas_right).offset(0);
        make.top.equalTo(_result_Lab.mas_bottom).offset(14);
        make.right.equalTo(baseView.mas_right).offset(-15);
    }];

    UILabel *time_TitleLab = [[UILabel alloc]init];
    [baseView addSubview:time_TitleLab];
    time_TitleLab.font = [UIFont systemFontOfSize:13];
    time_TitleLab.textColor = RGBA(51, 51, 51, 1);
    time_TitleLab.text = @"时间：";
    [time_TitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(baseView.mas_left).offset(29);
        make.top.equalTo(_content_Lab.mas_bottom).offset(14);
    }];

    self.time_Lab = [[UILabel alloc]init];
    [baseView addSubview:_time_Lab];
    _time_Lab.textColor = RGBA(102, 102, 102, 1);
    _time_Lab.font = [UIFont systemFontOfSize:13];
//    _time_Lab.text = @"  ";
    [_time_Lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(time_TitleLab.mas_right).offset(0);
        make.top.equalTo(_content_Lab.mas_bottom).offset(14);
    }];
    
    UILabel *user_TitleLab = [[UILabel alloc]init];
    [baseView addSubview:user_TitleLab];
    user_TitleLab.font = [UIFont systemFontOfSize:13];
    user_TitleLab.textColor = RGBA(51, 51, 51, 1);
    user_TitleLab.text = @"操作人：";
    [user_TitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(baseView.mas_left).offset(16);
        make.top.equalTo(time_TitleLab.mas_bottom).offset(14);
    }];

    self.user_Lab = [[UILabel alloc]init];
    [baseView addSubview:_user_Lab];
    _user_Lab.textColor = RGBA(102, 102, 102, 1);
    _user_Lab.font = [UIFont systemFontOfSize:13];
//    _user_Lab.text = @" ";
    [_user_Lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(user_TitleLab.mas_right).offset(0);
        make.top.equalTo(_time_Lab.mas_bottom).offset(14);
    }];
    
    UILabel *zhaiYao_TitleLab = [[UILabel alloc]init];
    [baseView addSubview:zhaiYao_TitleLab];
    zhaiYao_TitleLab.textColor = RGBA(51, 51, 51, 1);
    zhaiYao_TitleLab.text = @"摘要：";
    zhaiYao_TitleLab.font = [UIFont systemFontOfSize:13];
    [zhaiYao_TitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(baseView.mas_left).offset(29);
        make.top.equalTo(user_TitleLab.mas_bottom).offset(14);
    }];

    self.zhaiYao_Lab = [[UILabel alloc]init];
    [baseView addSubview:_zhaiYao_Lab];
    _zhaiYao_Lab.textColor = RGBA(102, 102, 102, 1);
    _zhaiYao_Lab.font = [UIFont systemFontOfSize:13];
    _zhaiYao_Lab.textAlignment = 0;
    _zhaiYao_Lab.numberOfLines = 0;
//    _zhaiYao_Lab.text = @"  ";
    [_zhaiYao_Lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(zhaiYao_TitleLab.mas_right).offset(0);
        make.top.equalTo(_user_Lab.mas_bottom).offset(14);
        make.right.equalTo(baseView.mas_right).offset(-16);
    }];
    
    self.photo_TitleLab = [[UILabel alloc]init];
    [baseView addSubview:_photo_TitleLab];
    _photo_TitleLab.textColor = RGBA(51, 51, 51, 1);
    _photo_TitleLab.text = @"图片：";
    _photo_TitleLab.font = [UIFont systemFontOfSize:13];
    [_photo_TitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(baseView.mas_left).offset(29);

    }];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _itemWH = (SCREEN_WIDTH - 109)/3 ;
    layout.itemSize = CGSizeMake(_itemWH, _itemWH / 16 * 9);


    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0,0) collectionViewLayout:layout];
    [baseView addSubview:_collectionView];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator = FALSE;
    self.collectionView.scrollEnabled = NO;
    [self.collectionView registerNib:[UINib nibWithNibName:@"ESSPhotoCell" bundle:nil] forCellWithReuseIdentifier:@"ESSPhotoCell"];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_photo_TitleLab.mas_right);
        make.right.equalTo(baseView.mas_right);
//        make.height.mas_equalTo(_itemWH * ((_dataArray.count/4)+1)+29);
    }];
    
    
    [baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(_collectionView.mas_bottom).offset(20);
    }];

    
    [self downloadData];
    
}

- (void)downloadData {
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setValue:self.LogId forKey:@"ProcessRecordID"];
    [ESSNetworkingTool GET:@"/APP/WB/Rescue_AlarmOrderTask/GetRescueRecordDetail" parameters:parameters success:^(NSDictionary * _Nonnull responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            _result_Lab.text = [NSString replaceEmptyString:responseObject[@"Description"]];
            _content_Lab.text = responseObject[@"RescueContent"];
            _time_Lab.text = [responseObject[@"CreateTime"] stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
            _user_Lab.text = responseObject[@"CreateName"];
            _zhaiYao_Lab.text = [NSString replaceEmptyString:responseObject[@"Remark"]];
            [_photo_TitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
                if (_zhaiYao_Lab.text.length > 0){
                    make.top.equalTo(_zhaiYao_Lab.mas_bottom).offset(14);
                }else{
                    make.top.equalTo(_zhaiYao_Lab.mas_bottom).offset(29);
                }
            }];
            
            NSString *tmp = [responseObject objectForKey:@"ImgURL"];
            
            if (tmp.length > 0) {
                self.dataArray = [[responseObject[@"ImgURL"] componentsSeparatedByString:@","] mutableCopy];
            }
            [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
                if (_zhaiYao_Lab.text.length > 0){
                    make.top.equalTo(_zhaiYao_Lab.mas_bottom).offset(14);
                }else{
                    make.top.equalTo(_zhaiYao_Lab.mas_bottom).offset(29);
                }
                make.height.mas_equalTo(_itemWH * ((_dataArray.count/3)+1 + 29));
                [self.collectionView reloadData];
            }];
        }
    }];
}


#pragma mark -- UICollectionViewDataSource

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ESSPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ESSPhotoCell" forIndexPath:indexPath];
    cell.deleteBtn.hidden = YES;
    if (indexPath.row < _dataArray.count) {
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:_dataArray[indexPath.row]] placeholderImage:[UIImage imageNamed:@"image_empty"]];
//        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:_dataArray[indexPath.row]]];
    }
    return cell;
}

////设置每个item的UIEdgeInsets
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(10, 0, 0, 10);
//}
//
////设置每个item水平间距
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 10;
//}
//
//
////设置每个item垂直间距
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 15;
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // Browser
    self.photos = [[NSMutableArray alloc] init];
    BOOL displayActionButton = YES;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = NO;
    BOOL enableGrid = YES;
    BOOL startOnGrid = NO;
    BOOL autoPlayOnAppear = NO;
    MWPhoto *photo;
    
    
    for (int i = 0; i < _dataArray.count; i++) {
        NSString *tmp = _dataArray[i];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:tmp]];
        [_photos addObject:photo];
    }
    
    // Create browser
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = displayActionButton;
    browser.displayNavArrows = displayNavArrows;
    browser.displaySelectionButtons = displaySelectionButtons;
    browser.alwaysShowControls = displaySelectionButtons;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = enableGrid;
    browser.startOnGrid = startOnGrid;
    browser.enableSwipeToDismiss = NO;
    browser.autoPlayOnAppear = autoPlayOnAppear;
    [browser setCurrentPhotoIndex:0];
    [self.navigationController pushViewController:browser animated:YES];
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

@end
