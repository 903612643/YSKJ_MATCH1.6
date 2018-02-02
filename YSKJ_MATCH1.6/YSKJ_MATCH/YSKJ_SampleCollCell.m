//
//  YSKJ_SampleCollCell.m
//  YSKJ_MATCH
//
//  Created by YSKJ on 17/11/13.
//  Copyright © 2017年 com.yskj. All rights reserved.
//

#import "YSKJ_SampleCollCell.h"

#import <SDWebImage/UIButton+WebCache.h>

#import <SDWebImage/UIImageView+WebCache.h>

@implementation YSKJ_SampleCollCell


-(id)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIButton *button = [[UIButton alloc] initWithFrame:self.bounds];
        self.button = button ;
        [self addSubview:button];
        
    }
    return self;
}

-(void)setUrl:(NSString *)url
{
    _url = url;
    
    [self.button sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal placeholderImage:nil];
    
    //获取网络图片的Size
    [self.button.imageView sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:url] placeholderImage:nil options:(SDWebImageRetryFailed) progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        // 耗时的操作
        float imageW=self.frame.size.width;
        float scaleW;
        if (image.size.width>=image.size.height) {
            scaleW=imageW/image.size.width;
        }else{
            scaleW=imageW/image.size.height;
        }
        
        if (image.size.width>0&&image.size.height>0) {
            
            self.button.imageEdgeInsets=UIEdgeInsetsMake((self.button.frame.size.height-scaleW*(image.size.height))/2, (self.button.frame.size.width-scaleW*(image.size.width))/2, (self.button.frame.size.height-scaleW*(image.size.height))/2, (self.button.frame.size.width-scaleW*(image.size.width))/2);
        }

        
    }];


}

@end
