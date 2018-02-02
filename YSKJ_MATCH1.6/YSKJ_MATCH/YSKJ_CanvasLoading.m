//
//  YSKJ_CanvasLoading.m
//  YSKJ
//
//  Created by YSKJ on 17/9/21.
//  Copyright © 2017年 5164casa.com. All rights reserved.
//

#import "YSKJ_CanvasLoading.h"

#import <SDAutoLayout/SDAutoLayout.h>

#import "AnimatedGif.h"

#define UIColorFromHex(s)  [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1]

#define BG_WIDTH 180
#define BG_HEIGHT 60
#define DISTANCE_WIDTH 82 //其他长度  //背景长度 ＝ 文字长度 ＋ 其他长度
#define LEFT_WIDTH 62 //文字距左边的宽度
#define SELFTAG 2017

@implementation YSKJ_CanvasLoading

-(id)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        
        self.bgView = [[UILabel alloc] init];
        self.bgView.backgroundColor = [UIColor colorWithRed:47.013/255.0 green:47.013/255.0 blue:47.013/255.0 alpha:0.6];
        self.bgView.layer.cornerRadius = 6;
        self.bgView.layer.masksToBounds = YES;
        [self addSubview:self.bgView];
        self.bgView.sd_layout
        .leftSpaceToView(self,(self.frame.size.width-BG_WIDTH)/2)
        .topSpaceToView(self,(self.frame.size.height-BG_HEIGHT)/2)
        .heightIs(BG_HEIGHT)
        .widthIs(BG_WIDTH);
        
        UIImageView *loadimage = [[UIImageView alloc] init];
        NSURL *localUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"loading" ofType:@"gif"]];
        loadimage= [AnimatedGif getAnimationForGifAtUrl:localUrl];
        _loadingGifView = loadimage;
        [self.bgView addSubview:loadimage];
        loadimage.sd_layout
        .leftSpaceToView(self.bgView,20)
        .topSpaceToView(self.bgView,10)
        .widthIs(40)
        .heightEqualToWidth();
        
        UIImageView *finishView = [[UIImageView alloc] init];
        _finishImageView = finishView;
        finishView.tag = 101;
        finishView.hidden = YES;
        [self.bgView addSubview:finishView];
        finishView.sd_layout
        .leftSpaceToView(self.bgView,20)
        .topSpaceToView(self.bgView, 14)
        .widthIs(32)
        .heightEqualToWidth();
    
        self.lable = [[UILabel alloc] init];
        self.lable.textAlignment = NSTextAlignmentLeft;
        self.lable.textColor = UIColorFromHex(0xffffff);
        [self.bgView addSubview:self.lable];
        
        self.lable.sd_layout
        .rightSpaceToView(self.bgView,20)
        .topSpaceToView(self.bgView,16)
        .bottomSpaceToView(self.bgView,16)
        .leftSpaceToView(self.bgView,LEFT_WIDTH);
        
        self.onlyGifImageView = [[UIImageView alloc] init];
        NSURL *localUrl1 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"loading" ofType:@"gif"]];
        self.onlyGifImageView= [AnimatedGif getAnimationForGifAtUrl:localUrl1];
        self.onlyGifImageView.hidden = YES;
        [self addSubview:self.onlyGifImageView];
        self.onlyGifImageView.sd_layout
        .centerXEqualToView(self)
        .centerYEqualToView(self)
        .widthIs(48)
        .heightEqualToWidth();

    }
    
    return self;
    
}

-(instancetype)initWithViewtext:(NSString *)text loadType:(LoadingStatus)type
{
    if (type == isBack) {

        float weight = [UIApplication sharedApplication].keyWindow.frame.size.width - 60;

        float height = [UIApplication sharedApplication].keyWindow.frame.size.height;

        CGRect selfBounds = CGRectMake(60, 0, weight, height);

        if ([self initWithFrame:selfBounds]) {

            self.lable.text = text;
            
            NSDictionary *attribute = @{NSFontAttributeName: self.lable.font};
            CGSize labelsize  = [text boundingRectWithSize:CGSizeMake(1000, 100) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
            
            self.bgView.sd_layout
            .leftSpaceToView(self,(self.frame.size.width-(labelsize.width + DISTANCE_WIDTH + 8))/2)
            .widthIs(labelsize.width + DISTANCE_WIDTH + 8);
            [self.bgView updateLayout];
            
            self.lable.sd_layout
            .leftSpaceToView(self.bgView,LEFT_WIDTH+8);
            [self.lable updateLayout];

        }

    }else{
    
         if ([self initWithFrame:[UIApplication sharedApplication].keyWindow.bounds]) {
        
                self.lable.text = text;
             
                 NSDictionary *attribute = @{NSFontAttributeName: self.lable.font};
                 CGSize labelsize  = [text boundingRectWithSize:CGSizeMake(1000, 100) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        
                self.bgView.sd_layout
                .leftSpaceToView(self,(self.frame.size.width-(labelsize.width + DISTANCE_WIDTH))/2)
                .widthIs(labelsize.width + DISTANCE_WIDTH);
                [self.bgView updateLayout];
        
                self.lable.sd_layout
                .leftSpaceToView(self.bgView,LEFT_WIDTH);
                [self.lable updateLayout];
             
                 if (type == loading){
                     
                     _loadingGifView.hidden = NO;
                     _finishImageView.hidden = YES;
                     
                 }else  if (type == finishing) {
                     
                     _loadingGifView.hidden = YES;
                     _finishImageView.hidden = NO;
                      _finishImageView.image = [UIImage imageNamed:@"finish"];
                     
                 }else if (type == fail){
                     
                     _loadingGifView.hidden = YES;
                     _finishImageView.hidden = NO;
                     _finishImageView.image = [UIImage imageNamed:@"Error1"];
                     
                 }else if (type == onlyText){
                     
                     _loadingGifView.hidden = YES;
                     _finishImageView.hidden = YES;
                     
                     self.bgView.sd_layout
                     .leftSpaceToView(self,(self.frame.size.width-(labelsize.width + 40))/2)
                     .widthIs(labelsize.width + 40);
                     [self.bgView updateLayout];
                     
                     self.lable.sd_layout
                     .leftSpaceToView(self.bgView,20);
                     [self.lable updateLayout];
                     
                 }
     
        }
    
    }

    return self;
    
}

+(void)showNotificationViewWithText:(NSString *)text loadType:(LoadingStatus)type;
{
    if (type == done) {
        
        for (UIView *subView in [UIApplication sharedApplication].keyWindow.subviews) {
            if (subView.tag == SELFTAG) {
                [subView removeFromSuperview];
            }
        }
        
    }else{
        
        YSKJ_CanvasLoading *view = [[YSKJ_CanvasLoading alloc] initWithViewtext:text loadType:type];
        view.tag = SELFTAG;
        [[UIApplication sharedApplication].keyWindow addSubview:view];
        
        if (type == finishing || type == fail || type == onlyText) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [view removeFromSuperview];
                
            });
        }
    }
    
}


@end
