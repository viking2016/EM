//
//  ESSPhotoView.m
//  ElevatorSecuritySystem
//
//  Created by cz q on 2017/5/10.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "ESSPhotoView.h"
//#import "SDPhotoBrowser.h"
#import <MWPhotoBrowser.h>

@interface ESSPhotoView ()<MWPhotoBrowserDelegate>

@property (nonatomic,strong)NSMutableArray *selections;

@end

static const CGFloat lb_H = 30;
static const CGFloat margin = 10;
static const int countPerLine = 3;
@implementation ESSPhotoView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title images:(NSArray *)images {
    
    self.photoArray = images;
    CGFloat image_H = (frame.size.width - margin * (countPerLine + 1)) / countPerLine;
    int count = (int)(images.count - 1) / countPerLine + 1;
    
    CGFloat x = frame.origin.x;
    CGFloat y = frame.origin.y;
    CGFloat w = frame.size.width;
    CGFloat h = lb_H + count * image_H + (count - 1) *margin;
    
    self = [super initWithFrame:CGRectMake(x, y, w, h)];
    
    if (self) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(15, 6, 4, 17)];
        view.backgroundColor = MAINCOLOR;
        [self addSubview:view];
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(24, 0, self.frame.size.width,lb_H)];
        lb.font = [UIFont systemFontOfSize:14];
        [self addSubview:lb];
        [lb setText:title];
        for (int i = 0; i < images.count; i ++) {
            
            CGFloat x = margin + i % countPerLine * (image_H + margin);
            CGFloat y = lb_H + (int)i / countPerLine * (image_H + margin);
            CGFloat w = image_H;
            CGFloat h = image_H;
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
            [self addSubview:imageView];
            [imageView sd_setImageWithURL:images[i] placeholderImage:[UIImage imageNamed:@"image_empty"]];
            imageView.backgroundColor = [UIColor whiteColor];

            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageView:)];
            imageView.tag = i;
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:tap];
        }
    }
    return self;
}

//点击图片  加载图片浏览器
-(void)tapImageView:(UITapGestureRecognizer *)tap
{
    if (_photoArray.count > tap.view.tag) {
        // Browser
        NSMutableArray *photos = [[NSMutableArray alloc] init];
        BOOL displayActionButton = YES;
        BOOL displaySelectionButtons = NO;
        BOOL displayNavArrows = NO;
        BOOL enableGrid = YES;
        BOOL startOnGrid = NO;
        BOOL autoPlayOnAppear = NO;
        MWPhoto *photo;
        
        
        for (int i = 0; i < _photoArray.count; i++) {
            NSString *tmp = _photoArray[i];
            photo = [MWPhoto photoWithURL:[NSURL URLWithString:tmp]];
            //            photo.caption = @"Tube";
            [photos addObject:photo];
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
        
        self.photos = photos;

        
        if (displaySelectionButtons) {
            _selections = [NSMutableArray new];
            for (int i = 0; i < photos.count; i++) {
                [_selections addObject:[NSNumber numberWithBool:NO]];
            }
        }
        
        [[self viewController].navigationController pushViewController:browser animated:YES];        
    }
}


//获取View所在的Viewcontroller方法
- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) { UIResponder *nextResponder = [next nextResponder]; if ([nextResponder isKindOfClass:[UIViewController class]]) { return (UIViewController *)nextResponder; } } return nil; }

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
