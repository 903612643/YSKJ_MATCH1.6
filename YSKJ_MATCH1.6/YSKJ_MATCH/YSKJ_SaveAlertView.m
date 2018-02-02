//
//  YSKJ_SaveAlertView.m
//  YSKJ_MATCH
//
//  Created by YSKJ on 17/11/13.
//  Copyright © 2017年 com.yskj. All rights reserved.
//

#import "YSKJ_SaveAlertView.h"

#define UIColorFromHex(s)  [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1]

@implementation YSKJ_SaveAlertView


-(id)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        
        [self addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 182, 100)];
        view.backgroundColor = UIColorFromHex(0x2cbbfd);
        [self addSubview:view];
        
        UIButton *cancle = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        cancle.backgroundColor = UIColorFromHex(0x00abf2);
        [cancle setImage:[UIImage imageNamed:@"Return"] forState:UIControlStateNormal];
        [cancle addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:cancle];
        
        UIButton *save = [[UIButton alloc] initWithFrame:CGRectMake(50, 0, 132, 50)];
        [save setTitle:@"保存方案" forState:UIControlStateNormal];
        save.titleLabel.font = [UIFont systemFontOfSize:17];
        [save setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [save addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:save];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(50, 49, 132, 1)];
        line.backgroundColor = UIColorFromHex(0x00abf2);
        [view addSubview:line];
        
        UIButton *giveUp = [[UIButton alloc] initWithFrame:CGRectMake(0, 50, 50, 50)];
        giveUp.backgroundColor = UIColorFromHex(0x2cbbfd);
        [giveUp setImage:[UIImage imageNamed:@"SignOut"] forState:UIControlStateNormal];
        [giveUp addTarget:self action:@selector(giveUpeditAction) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:giveUp];
        
        UIButton *giveUpedit = [[UIButton alloc] initWithFrame:CGRectMake(50,50, 132, 50)];
        [giveUpedit setTitle:@"返回到主菜单" forState:UIControlStateNormal];
        [giveUpedit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [giveUpedit addTarget:self action:@selector(giveUpeditAction) forControlEvents:UIControlEventTouchUpInside];
        save.titleLabel.font = [UIFont systemFontOfSize:17];
        [view addSubview:giveUpedit];
        
        
    }
    
    return self;
}

-(void)saveAction
{
    [self removeFromSuperview];
    
    if (self.saveBlock) {
        self.saveBlock();
    }
}

-(void)giveUpeditAction
{
    [self removeFromSuperview];
    
    if (self.cancleBlock) {
        self.cancleBlock();
    }
}

-(void)cancleAction
{
    [self removeFromSuperview];
}

-(instancetype)initSelf
{
    if ([self initWithFrame:CGRectMake(0, 0, [UIApplication sharedApplication].keyWindow.frame.size.width, [UIApplication sharedApplication].keyWindow.frame.size.height)]) {
  
        
    }
    return self;
}

+(void)showSaveAlertCancleBlock:(cancleBlock)cancleBlock saveBlock:(saveBlock)saveBlock;
{
    YSKJ_SaveAlertView *alert = [[YSKJ_SaveAlertView alloc] initSelf];
    
    alert.cancleBlock = cancleBlock;
    
    alert.saveBlock = saveBlock;
    
    [[UIApplication sharedApplication].keyWindow addSubview:alert];
}


@end
