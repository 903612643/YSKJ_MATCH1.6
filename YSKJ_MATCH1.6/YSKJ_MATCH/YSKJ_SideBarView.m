//
//  YSKJ_SideBarView.m
//  YSKJ_MATCH
//
//  Created by YSKJ on 17/10/30.
//  Copyright © 2017年 com.yskj. All rights reserved.
//

#import "YSKJ_SideBarView.h"

#define UIColorFromHex(s)  [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1]

@implementation YSKJ_SideBarView

-(id)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        
        self.backgroundColor = UIColorFromHex(0x354048);
        
        self.headBut = [[UIButton alloc] initWithFrame:CGRectMake(16, 25+70, 48, 48)];
        
        [self.headBut setImage:[UIImage imageNamed:@"wode"] forState:UIControlStateNormal];
        
        self.headBut.layer.cornerRadius = 24;
        
        self.headBut.layer.masksToBounds = YES;
        
        [self addSubview:self.headBut];
        
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 25+70+48+5, self.frame.size.width, 20)];
        title.font = [UIFont systemFontOfSize:12];
        title.textColor = UIColorFromHex(0xb1c0c8);
        title.textAlignment = NSTextAlignmentCenter;
        title.text = @"我的";
        [self addSubview:title];
        
        
        self.match = [[UIButton alloc] initWithFrame:CGRectMake(16, 185+70, 48, 80)];
        
        [self.match setTitle:@"做搭配" forState:UIControlStateNormal];
        
        self.match.titleLabel.font = [UIFont systemFontOfSize:12];
        
        [self.match setTitleColor:UIColorFromHex(0xb1c0c8) forState:UIControlStateNormal];
        
        [self.match setImage:[UIImage imageNamed:@"collocation"] forState:UIControlStateNormal];
        
        self.match.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        
        [self.match setTitleEdgeInsets:UIEdgeInsetsMake(self.match.imageView.frame.size.height +8,-self.match.imageView.frame.size.width, 0.0,0.0)];
        
        [self.match setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0,0.0, -self.match.titleLabel.bounds.size.width)];
        
        [self addSubview:self.match];
        
    }
    
    return self;
    
}

-(void)setImage:(UIImage *)image
{
    _image = image;
    [self.headBut setImage:image forState:UIControlStateNormal];
    
}

@end
