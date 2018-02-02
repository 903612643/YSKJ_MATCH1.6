//
//  YSKJ_SingleCollCell.m
//  YSKJ_MATCH
//
//  Created by YSKJ on 17/11/9.
//  Copyright © 2017年 com.yskj. All rights reserved.
//

#import "YSKJ_SingleCollCell.h"

#import <SDWebImage/UIButton+WebCache.h>

#import <SDWebImage/UIImageView+WebCache.h>

#import "YSKJ_drawModel.h"

#import <MJExtension/MJExtension.h>

#import "YSKJ_DrawData.h"

#define UIColorFromHex(s)  [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1]

@implementation YSKJ_SingleCollCell

-(id)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, self.frame.size.width-20, self.frame.size.height-20)];
        _proBut = button;
        [self addSubview:button];
        
        UIButton *panBut = [[UIButton alloc] initWithFrame:CGRectMake(30, (self.frame.size.width-20)/2, self.frame.size.width-60, 30)];
         panBut.alpha = 0.03;
        _panBut = panBut;
        [self addSubview:panBut];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [panBut addGestureRecognizer:pan];
    
        UIButton *addToCanvasBut = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 36, 1, 36, 36)];
        [addToCanvasBut addTarget:self action:@selector(addToCanvas:) forControlEvents:UIControlEventTouchUpInside];
        addToCanvasBut.backgroundColor = [UIColor clearColor];
        addToCanvasBut.layer.cornerRadius = 5;
        addToCanvasBut.layer.masksToBounds = YES;
        [addToCanvasBut setImage:[UIImage imageNamed:@"AddTo"] forState:UIControlStateNormal];
        [self addSubview:addToCanvasBut];
        
        
  
    }
    return self;
}
-(void)addToCanvas:(UIButton *)sender
{
    NSURL *url = [NSURL URLWithString:[self.obj objectForKey:@"thumb_file"]];
    
    [sender.imageView sd_setImageWithPreviousCachedImageWithURL:url placeholderImage:[UIImage imageNamed:@"loading1"] options:(SDWebImageRetryFailed) progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        if (image==nil) {
            return ;
        }
        [YSKJ_DrawData getDrawDataJsonDict:@{@"image":image,
                                             @"src":[self.obj objectForKey:@"thumb_file"],
                                             @"pid":[self.obj objectForKey:@"id"]
                                             }  objType:(product) WithBlock:^(YSKJ_drawModel *model) {
                                                 NSDictionary *userInfo = @{
                                                                            @"model":model,
                                                                            };
                                                 [[NSNotificationCenter defaultCenter] postNotificationName:@"addToCanvasNotification" object:nil userInfo:userInfo];
                                                 
                                             }];

        
    }];

}

-(void)pan:(UIPanGestureRecognizer*)ges
{
    UIButton *button = (UIButton *)ges.view;

    button.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    if (panImage.size.width>=panImage.size.height) {
        panScale = button.frame.size.width/panImage.size.width;
    }else{
        panScale = button.frame.size.width/panImage.size.height;
    }
    
    button.imageEdgeInsets=UIEdgeInsetsMake((button.frame.size.height-panScale*(panImage.size.height))/2, (button.frame.size.width-panScale*(panImage.size.width))/2, (button.frame.size.height-panScale*(panImage.size.height))/2, (button.frame.size.width-panScale*(panImage.size.width))/2);
    
    NSDictionary *dict = @{@"ges":ges,
                           @"button":ges.view,
                           @"dict":self.obj
                           };
    [[NSNotificationCenter defaultCenter] postNotificationName:@"panNotification" object:nil userInfo:dict];
    
    if (ges.state == UIGestureRecognizerStateBegan) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"beganPanNotification" object:nil userInfo:dict];
    }
    
    if (ges.state == UIGestureRecognizerStateEnded || ges.state == UIGestureRecognizerStateFailed){

        UIImageView *imageView = [[UIImageView alloc] init];
        //获取网络图片的Size
        [imageView sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:[self.obj objectForKey:@"thumb_file"]] placeholderImage:nil options:(SDWebImageRetryFailed) progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
        } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            
            NSDictionary *dict = @{@"ges":ges,
                                   @"button":ges.view,
                                   @"dict":@{
                                           @"thumb_file":[self.obj objectForKey:@"thumb_file"],
                                           @"id":[self.obj objectForKey:@"id"],
                                           @"netW":[NSString stringWithFormat:@"%f",image.size.width],
                                           @"netH":[NSString stringWithFormat:@"%f",image.size.height]
                                           }
                                   };
            [[NSNotificationCenter defaultCenter] postNotificationName:@"endPanNotification" object:nil userInfo:dict];
            
            
        }];

        
    }
    
}


-(void)setObj:(NSDictionary *)obj
{
    _obj = obj;
    
    NSURL *url = [NSURL URLWithString:[obj objectForKey:@"thumb_file"]];
    
    // 更新界面
    [self.proBut sd_setImageWithURL:url forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"loading1"]];
    
    [self.panBut sd_setImageWithURL:url forState:UIControlStateNormal placeholderImage:nil];
    
    //获取网络图片的Size
    [self.proBut.imageView sd_setImageWithPreviousCachedImageWithURL:url placeholderImage:nil options:(SDWebImageRetryFailed) progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    
        // 耗时的操作
        float imageW=self.frame.size.width - 20;
        float imageW1=self.frame.size.width - 60;
        float scaleW,scaleW1;
        if (image.size.width>=image.size.height) {
            scaleW=imageW/image.size.width;
            scaleW1=imageW1/image.size.width;
        }else{
            scaleW=imageW/image.size.height;
            scaleW1=imageW1/image.size.height;
        }
        panImage = image;
        
        if (image.size.width>0&&image.size.height>0) {
            
            self.proBut.imageEdgeInsets=UIEdgeInsetsMake((self.proBut.frame.size.height-scaleW*(image.size.height))/2, (self.proBut.frame.size.width-scaleW*(image.size.width))/2, (self.proBut.frame.size.height-scaleW*(image.size.height))/2, (self.proBut.frame.size.width-scaleW*(image.size.width))/2);
            
            self.panBut.imageEdgeInsets=UIEdgeInsetsMake((self.panBut.frame.size.height-scaleW1*(image.size.height))/2, (self.panBut.frame.size.width-scaleW1*(image.size.width))/2, (self.panBut.frame.size.height-scaleW1*(image.size.height))/2, (self.panBut.frame.size.width-scaleW1*(image.size.width))/2);
        }
        
    }];

    
    
}



@end
