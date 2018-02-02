//
//  YSKJ_NaviView.m
//  YSKJ_MATCH
//
//  Created by YSKJ on 17/10/31.
//  Copyright © 2017年 com.yskj. All rights reserved.
//

#import "YSKJ_NaviView.h"

#define UIColorFromHex(s)  [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1]

@implementation YSKJ_NaviView

-(id)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        
        self.close = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 50, 50)];
        self.close.backgroundColor = UIColorFromHex(0x00abf2);
        [self.close setImage:[UIImage imageNamed:@"Return"] forState:UIControlStateNormal];
        [self addSubview:self.close];
        self.backgroundColor = UIColorFromHex(0x293136);
        
        UIButton *deleAll = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 80, 23, 60, 44)];
        self.moveAllBut = deleAll;
        [deleAll setTitle:@"清空" forState:UIControlStateNormal];
        deleAll.titleLabel.font = [UIFont systemFontOfSize:14];
        [deleAll setTitleColor:UIColorFromHex(0xb1c0c8) forState:UIControlStateNormal];
        [self addSubview:deleAll];
        
        UIButton *order = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 250, 23, 60, 44)];
        self.orderBtn = order;
        order.backgroundColor = [UIColor clearColor];
        [order setTitle:@"方案清单" forState:UIControlStateNormal];
        order.titleLabel.font = [UIFont systemFontOfSize:14];
        [order setTitleColor:UIColorFromHex(0xb1c0c8) forState:UIControlStateNormal];
        [self addSubview:order];
        
        UIButton *export = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 170, 23, 80, 44)];
        self.exportBtn = export;
        export.backgroundColor = [UIColor clearColor];
        [export setTitle:@"导出效果图" forState:UIControlStateNormal];
        export.titleLabel.font = [UIFont systemFontOfSize:14];
        [export setTitleColor:UIColorFromHex(0xb1c0c8) forState:UIControlStateNormal];
        [self addSubview:export];
        
        UIButton *autosaveBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 350, 25, 76, 44)];
        autosaveBtn.imageEdgeInsets = UIEdgeInsetsMake(7, 0, 7, 0);
        [autosaveBtn setImage:[UIImage imageNamed:@"CloseAutoSave"] forState:UIControlStateNormal];
        _autosaveBtn = autosaveBtn;
        [self addSubview:autosaveBtn];
        
        NSArray *image = @[@"Unlock",@"Revoke",@"Forward",@"mirror",@"copy",@"BringForward",@"setRight",@"delete.jpg"];
        NSArray *heiImage = @[@"Unlock1",@"Revoke1",@"Forward1",@"mirror1",@"copy1",@"BringForward1",@"setRight1",@"delete1.jpg"];
        for (int i=0; i<image.count; i++) {
            UIButton *but = [[UIButton alloc] initWithFrame:CGRectMake(80 + 44*i+20*i, 23, 44, 44)];
            but.tag = 1000 + i;
            but.enabled = NO;
            [but setImage:[UIImage imageNamed:image[i]] forState:UIControlStateNormal];
            [but setImage:[UIImage imageNamed:heiImage[i]] forState:UIControlStateHighlighted];
            but.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
            [self addSubview:but];
        }
        
    }
    return self;
}


@end
