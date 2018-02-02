//
//  YSKJ_CateCollCell.m
//  YSKJ_MATCH
//
//  Created by YSKJ on 17/11/1.
//  Copyright © 2017年 com.yskj. All rights reserved.
//

#import "YSKJ_CateCollCell.h"

#define UIColorFromHex(s)  [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1]

@implementation YSKJ_CateCollCell

-(id)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - 64- 8, self.frame.size.height - 64-8, 64, 64)];
        _imageView = imageView;
        [self addSubview:imageView];
        
        self.lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 48, 20)];
        self.lab.textColor = UIColorFromHex(0x666666);
        self.lab.textAlignment = NSTextAlignmentCenter;
        self.lab.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.lab];
        
    }
    return self;
}

-(void)setTitle:(NSString *)title
{
    _title = title;
    self.lab.text = title;
}

-(void)setImageName:(NSString *)imageName
{
    _imageName = imageName;
    
    _imageView.image = [UIImage imageNamed:imageName];
    
    float scale;
    
    if (_imageView.image.size.width>=_imageView.image.size.height) {
        
        scale = 64/_imageView.image.size.width;
        
        
    }else{
        scale = 64/_imageView.image.size.height;
    }
    
    _imageView.frame = CGRectMake(self.frame.size.width-scale*_imageView.image.size.width-8, self.frame.size.height-scale*_imageView.image.size.height-8, scale*_imageView.image.size.width, scale*_imageView.image.size.height);
    
    
}

@end
