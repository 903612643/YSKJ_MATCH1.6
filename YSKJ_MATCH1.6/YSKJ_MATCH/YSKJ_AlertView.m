//
//  YSKJ_AlertView.m
//  YSKJ_MATCH
//
//  Created by YSKJ on 17/11/6.
//  Copyright © 2017年 com.yskj. All rights reserved.
//

#import "YSKJ_AlertView.h"

#define UIColorFromHex(s)  [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1]

@implementation YSKJ_AlertView

-(id)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithRed:47/255.0 green:47/255.0 blue:47/255.0 alpha:0.6];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width - 356)/2, (self.frame.size.height - 172)/2, 356, 172)];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = 12;
        view.layer.masksToBounds = YES;
        [self addSubview:view];
        
        self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, view.frame.size.width, 24)];
        self.titleLab.font = [UIFont systemFontOfSize:17];
        self.titleLab.textColor = UIColorFromHex(0x030303);
        self.titleLab.textAlignment = NSTextAlignmentCenter;
        [view addSubview:self.titleLab];
        
        self.contentLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 68, view.frame.size.width, 18)];
        self.contentLab.font = [UIFont systemFontOfSize:13];
        self.contentLab.textAlignment = NSTextAlignmentCenter;
        self.contentLab.textColor = UIColorFromHex(0x030303);
        [view addSubview:self.contentLab];
        
        UIButton *cancle = [[UIButton alloc] initWithFrame:CGRectMake(53.5, 104, 76, 44)];
        [cancle setTitle:@"取消" forState:UIControlStateNormal];
        [cancle setTitleColor:UIColorFromHex(0x666666) forState:UIControlStateNormal];
        cancle.layer.cornerRadius = 4;
        cancle.layer.masksToBounds = YES;
        cancle.layer.borderColor = UIColorFromHex(0xdddddd).CGColor;
        cancle.layer.borderWidth = 1;
        cancle.backgroundColor = UIColorFromHex(0xf4f4f4);
        [cancle addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:cancle];
        
        UIButton *sure = [[UIButton alloc] initWithFrame:CGRectMake(view.frame.size.width - (76+53.5), 104, 76, 44)];
        [sure setTitle:@"确认" forState:UIControlStateNormal];
        [sure setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        sure.layer.cornerRadius = 4;
        sure.layer.masksToBounds = YES;
        sure.backgroundColor = UIColorFromHex(0x00abf2);
        [sure addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:sure];
        
        
    }
    return self;
}

-(void)cancleAction
{
    [self removeFromSuperview];
    
    if (self.cancleBlock) {
        self.cancleBlock();
    }
}

-(void)sureAction
{
    [self removeFromSuperview];
    
    if (self.finishBlock) {
        self.finishBlock();
    }
}

-(instancetype)initTitle:(NSString*)title content:(NSString *)content
{
    if ([self initWithFrame:CGRectMake(0, 0, [UIApplication sharedApplication].keyWindow.frame.size.width, [UIApplication sharedApplication].keyWindow.frame.size.height)]) {
        
        self.titleLab.text = title;
        self.contentLab.text = content;
        
        
    }
    return self;
}

+(void)showAlertTitle:(NSString*)title content:(NSString*)content cancleBlock:(cancleBlock)cancleBlock finishBlock:(finishBlock)finishBlock;
{
    YSKJ_AlertView *alert = [[YSKJ_AlertView alloc] initTitle:title content:content];
    
    alert.cancleBlock = cancleBlock;
    
    alert.finishBlock = finishBlock;
    
    [[UIApplication sharedApplication].keyWindow addSubview:alert];
    
    
}

@end
