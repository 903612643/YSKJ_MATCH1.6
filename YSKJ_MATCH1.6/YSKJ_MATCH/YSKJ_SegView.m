//
//  YSKJ_SegView.m
//  YSKJ_MATCH
//
//  Created by YSKJ on 17/11/3.
//  Copyright © 2017年 com.yskj. All rights reserved.
//

#import "YSKJ_SegView.h"

#define UIColorFromHex(s)  [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1]

@implementation YSKJ_SegView

-(id)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        
        self.backgroundColor = UIColorFromHex(0x354048);
        
        self.titeleArray = @[@"家具中心",@"饰品中心",@"生活物件"];
        
        for (int i=0; i<self.titeleArray.count; i++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(50+(self.frame.size.width-100-80*3)/2*i + 80*i, 0, 80, 44)];
            [button setTitle:self.titeleArray[i] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:16];
            button.tag = 100+i;
            [button addTarget:self action:@selector(choose:) forControlEvents:UIControlEventTouchUpInside];
            UIColor *titleC =  UIColorFromHex(0xb1c0c8);
            [button setTitleColor:titleC forState:UIControlStateNormal];
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            [self addSubview:button];
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(50+(self.frame.size.width-100-button.frame.size.width*3)/2*i + 80*i, 40, button.frame.size.width, 1)];
            line.tag = 200+i;
            [self addSubview:line];
            
            if (i==0) {
                [self choose:button];
            }
            
        }
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
