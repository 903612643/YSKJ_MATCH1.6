//
//  YSKJ_HeaderView.m
//  YSKJ_MATCH
//
//  Created by YSKJ on 18/1/22.
//  Copyright © 2018年 com.yskj. All rights reserved.
//

#import "YSKJ_HeaderView.h"

#define UIColorFromHex(s)  [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1]

@implementation YSKJ_HeaderView

-(id)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        
        self.titeleArray = @[@"我的单品",@"我的收藏"];
        
        for (int i=0;i<self.titeleArray.count; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(16 + 80*i +10*i, 21, 80, 22)];
            [btn setTitle:self.titeleArray[i] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(choose:) forControlEvents:UIControlEventTouchUpInside];
            btn.titleLabel.font = [UIFont systemFontOfSize:16];
            [btn setTitleColor:UIColorFromHex(0xb1c0c8) forState:UIControlStateNormal];
            btn.tag = 100+i;
            [self addSubview:btn];
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(16 + 80*i +10*i, 53, 80, 1)];
            line.tag = 200+i;
            [self addSubview:line];
            
            if (i==0) {
                [self choose:btn];
            }
        }
        
        UIButton *editPlan = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-120, 10, 44, 44)];
        [editPlan setTitle:@"编辑" forState:UIControlStateNormal];
        _editList = editPlan;
        [editPlan setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
        editPlan.titleLabel.font = [UIFont systemFontOfSize:16];
        editPlan.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        [self addSubview:editPlan];
        
        UIButton *upLoad = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-70, 10, 44, 44)];
        [upLoad setImage:[UIImage imageNamed:@"addPlan"] forState:UIControlStateNormal];
        _addBtn = upLoad;
        upLoad.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        [self addSubview:upLoad];
        
    }
    return self;
}

- (void)choose:(UIButton *)sender{
    
    for (int i = 0; i < self.titeleArray.count; i++) {
        
        UIButton *btn = (UIButton *)[[sender superview] viewWithTag:100 + i];
        UIView *line = (UIView *)[[sender superview] viewWithTag:200 + i];
        //选中当前按钮时
        if (sender.tag == btn.tag) {
            
            UIColor *titleC =  UIColorFromHex(0x00abf2);
            [btn setTitleColor:titleC forState:UIControlStateNormal];
            line.backgroundColor = UIColorFromHex(0x00abf2);
            line.hidden = NO;
            sender.selected = !sender.selected;
            
        }else{
            
            UIColor *titleC =  UIColorFromHex(0xb1c0c8);
            [btn setTitleColor:titleC forState:UIControlStateNormal];
            line.backgroundColor = UIColorFromHex(0x354048);
            line.hidden = YES;
            [btn setSelected:NO];
        }
    }
    
    if (self.selectBlock) {
        self.selectBlock(sender.tag - 100);
    }
}

@end
