//
//  YSKJ_spaListCollCell.m
//  YSKJ_MATCH
//
//  Created by YSKJ on 17/11/6.
//  Copyright © 2017年 com.yskj. All rights reserved.
//

#import "YSKJ_spaListCollCell.h"

#import <SDWebImage/UIButton+WebCache.h>

#import <SDWebImage/UIImageView+WebCache.h>

#import "YSKJ_drawModel.h"

#import <MJExtension/MJExtension.h>

#import "YSKJ_DrawData.h"

#define SPACEBGURL @"http://octjlpudx.qnssl.com/"      //空间背景绝对路径

#define UIColorFromHex(s)  [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1]

@implementation YSKJ_spaListCollCell

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        
        self.button = [[UIButton alloc] initWithFrame:CGRectMake(12, 12, self.frame.size.width - 24, self.frame.size.height - 24)];
        self.button.backgroundColor = UIColorFromHex(0xf2f2f2);
        [self addSubview:self.button];
        
        UIButton *addBut = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-16-36, 12, 36, 36)];
        [addBut setImage:[UIImage imageNamed:@"AddTo"] forState:UIControlStateNormal];
        addBut.backgroundColor = [UIColor clearColor];
        [addBut addTarget:self action:@selector(addToCanvas:) forControlEvents:UIControlEventTouchUpInside];
        addBut.layer.cornerRadius = 5;
        addBut.layer.masksToBounds = YES;
        [self addSubview:addBut];
 
    }
    
    return self;
}

-(void)addToCanvas:(UIButton *)sender
{
    [self.button.imageView sd_setImageWithPreviousCachedImageWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",self.url]] placeholderImage:[UIImage imageNamed:@"loading1"] options:(SDWebImageRetryFailed) progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        if (image==nil) {
            return ;
        }
        [YSKJ_DrawData getDrawDataJsonDict:@{@"image":image,
                                             @"src":self.url,
                                             @"pid":@"888"
                                             }  objType:(spacebg) WithBlock:^(YSKJ_drawModel *model) {
         NSDictionary *userInfo = @{
                                    @"model":model,
                                    };
         [[NSNotificationCenter defaultCenter] postNotificationName:@"addToCanvasNotification" object:nil userInfo:userInfo];
         
        }];
        
    }];
}

-(void)setUrl:(NSString *)url{
    
    _url = url;
    
    [self.button.imageView sd_setImageWithURL:[NSURL URLWithString:url] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
            if (image.size.width>0&&image.size.height>0) {
                
                float imageW=self.frame.size.width - 24;
                float scaleW;
                if (image.size.width>=image.size.height) {
                    scaleW=imageW/image.size.width;
                }else{
                    scaleW=imageW/image.size.height;
                }
                
                self.button.imageEdgeInsets=UIEdgeInsetsMake((self.button.frame.size.height-scaleW*(image.size.height))/2, (self.button.frame.size.width-scaleW*(image.size.width))/2, (self.button.frame.size.height-scaleW*(image.size.height))/2, (self.button.frame.size.width-scaleW*(image.size.width))/2);
            }
    
    }];
    
    [self.button sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@-appspacebgthumb",url]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"loading1"]];
    
}


@end
